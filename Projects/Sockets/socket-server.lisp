(require 'sb-bsd-sockets)

(defparameter *address* '(0 0 0 0))
(defparameter *port* 5003)

(defun create-socket ()
  (let ((socket (make-instance 'sb-bsd-sockets:inet-socket
                               :type :stream
                               :protocol :tcp)))
    (sb-bsd-sockets:socket-bind socket *address* *port*)
    (sb-bsd-sockets:socket-listen socket 5)
    socket))

(defun get-socket-stream (socket)
  (sb-bsd-sockets:socket-make-stream (sb-bsd-sockets:socket-accept socket)
                                     :output t
                                     :input t))

(defun socket-listen-loop (socket)
  (print "Listening loop...")
  (with-open-stream (stream (get-socket-stream socket))
    (princ (read-line stream))
    (princ "desra" stream))
  (socket-listen-loop socket))


(defun main ()
  (prin1 "Creating socket")
  (let ((socket (create-socket)))
    (prin1 "Starting listening")
    (unwind-protect
         (socket-listen-loop socket)
         (sb-bsd-sockets:socket-close socket))))
