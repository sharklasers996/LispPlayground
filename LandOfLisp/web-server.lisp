(require 'sb-bsd-sockets)

(defun http-char (c1 c2 &optional (default #\Space))
  (let ((code (parse-integer
               (coerce (list c1 c2) 'string)
               :radix 16 ; hex
               :junk-allowed t)))
    (if code
        (code-char code)
        default)))

(defun decode-param (s)
  (labels ((f (lst)
             (when lst
               (case (first lst)
                 (#\% (cons (http-char (rest lst) (third lst))
                            (f (cdddr lst))))
                 (#\+ (cons #\Space (f (rest lst))))
                 (otherwise (cons (first lst) (f (rest lst))))))))
    (coerce (f (coerce s 'list)) 'string)))


(defun parse-params (s)
  (let* ((i1 (position #\= s))
         (i2 (position #\& s)))
    (cond (i1 (cons (cons (intern (string-upcase (subseq s 0 i1)))
                          (decode-param (subseq s (1+ i1) i2)))
                    (and i2 (parse-params (subseq s (1+ i2))))))
          ((equal s "") nil)
          (t s))))

(defun parse-url (s)
  (let* ((url (subseq s
                      (+ 2 (position #\space s))
                      (position #\space s :from-end t)))
         (param-pos (position #\? url)))
    (if param-pos
        (cons (subseq url 0 param-pos) (parse-params (subseq url (1+ param-pos))))
        (cons url '()))))


(defun get-header (stream)
  (let* ((s (read-line stream))
         (h (let ((i (position #\: s)))
              (when i
                (cons (intern (string-upcase (subseq s 0 i)))
                      (subseq s (+ i 2)))))))
    (when h
      (cons h (get-header stream)))))


(defun get-content-params (stream header)
  (let ((length (rest (assoc 'content-length header))))
    (when length
      (let ((content (make-string (parse-integer length))))
        (read-sequence content stream)
        (parse-params content)))))

(defun create-socket (&optional (port 8080))
  (let ((socket (make-instance 'sb-bsd-sockets:inet-socket
                               :type :stream
                               :protocol :tcp)))
    (sb-bsd-sockets:socket-bind socket '(0 0 0 0) port)
    (sb-bsd-sockets:socket-listen socket 5)
    socket))

(defun get-socket-stream (socket)
  (sb-bsd-sockets:socket-make-stream (sb-bsd-sockets:socket-accept socket)
                                     :output t
                                     :input t))

(defun serve (request-handler)
  (let ((socket (create-socket)))
    (unwind-protect
         (loop (with-open-stream (stream (get-socket-stream socket))
                 (let* ((url (parse-url (read-line stream)))
                        (path (first url))
                        (header (get-header stream))
                        (params (append (rest url)
                                        (get-content-params stream header)))
                        (*standard-output* stream))
                   (funcall request-handler path header params))))
      (sb-bsd-sockets:socket-close socket))))


(defun hello-request-handler (path header params)
  (if (equal path "hello")
      (let ((name (assoc 'name params)))
        (if (not name)
            (princ "<!DOCTYPE html> <html><form>Name please:<input name='name'/></form></html>")
            (format t "<!DOCTYPE html> <html>Howdy ~a!</html>" (rest name))))
      (princ "Not found!")))
