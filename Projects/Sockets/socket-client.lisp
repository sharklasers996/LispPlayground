(require 'sb-bsd-sockets)

(defparameter *address* '(0 0 0 0))
(defparameter *port* 5003)


(defun create-socket ()
  (let ((socket (make-instance 'sb-bsd-sockets:inet-socket
                               :type :stream
                               :protocol :tcp)))
    (setf (sb-bsd-sockets:sockopt-reuse-address socket) t)
    (sb-bsd-sockets:socket-bind socket *address* *port*)
    ;; (sb-bsd-sockets:socket-connect socket *address*)
    ;; (sb-bsd-sockets:socket-listen socket 5)
    socket))


(defun get-socket-stream (socket)
  (sb-bsd-sockets:socket-make-stream (sb-bsd-sockets:socket-accept socket)
                                     :output t
                                     :input t))

(defparameter *socket* (create-socket))

(defun write-to-socket (data)
  (prin1 "Opening socket")
  (let ((socket (sb-bsd-sockets:socket-accept *socket*)))
    (print "Sending data")
    (unwind-protect
         (let ((stream (sb-bsd-sockets:socket-make-stream socket :output t)))
           (format stream "Sending: ~a" data))
      (sb-bsd-sockets:socket-close socket))))




(defparameter *my-sock* (make-instance 'sb-bsd-sockets:inet-socket
                                       :type :stream
                                       :protocol :tcp))



;; (OR (NULL (CONS SEQUENCE (CONS (UNSIGNED-BYTE 16)))))
;; (OR
;;  NULL
;;  (CONS
;;   SEQUENCE
;;   (CONS
;;    (UNSIGNED-BYTE
;;     16)))).
