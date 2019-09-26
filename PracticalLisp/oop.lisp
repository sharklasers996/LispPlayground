(defclass bank-account ()
  (name
   balance))

;; creating class instance
(defparameter *account* (make-instance 'bank-account))

;; setting class field value
(setf (slot-value *account* 'name) "Desrunas")

;; With named (:initarg) or default (:initform) parameters
(defclass bank-account-named-default ()
  ((name :initarg :name
         :initform (error "Must supply name!"))
   (balance :initarg :balance
            :initform 13)))

(defparameter *account-named* (make-instance 'bank-account-named-default :name "desraite"))

;; throws error since name is mandatory
;; (defparameter *account-named2* (make-instance 'bank-account-named-default))



;; function to set class' field (as in not writing value directly into class' field)
;; :accessor can also be used to define default field to write/read
;; or :reader :writer can be used (:accessor creates both of these)
(defun (setf set-name) (name account)
  (setf (slot-value account 'name) name))

(setf (set-name *account-named*) "Name from setf function")

