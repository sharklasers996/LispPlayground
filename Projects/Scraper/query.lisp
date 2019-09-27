(ql:quickload :plump)

(defpackage :query-test
  (:use :common-lisp)
  (:use :plump-dom)
  (:shadow :element))

(use-package :plump-dom)
(in-package :query-test)

(defvar *page* (plump:parse "<html><a href=\"url.html\">Desraites</a> </html>"))

(defvar *html-node* (elt (plump:children *page*) 0))
(defparameter *a-node* (plump:first-child *html-node*))

(defparameter *tag-name* nil)
;; (defvar *tag-name* (tag-name *a-node*))

(defparameter *test-node* t)

(defun get-file (filename)
  (with-open-file (stream filename)
    (loop for line = (read-line stream nil)
          while line
          collect line)))

(defun init-test-node ()
  (let* ((file-lines (with-open-file (stream "C:\\Users\\PonasPx\\Documents\\test.html")
                      (loop for line = (read-line stream nil)
                            while line
                            collect line)))
         (trimmed-lines (mapcar #'(lambda (x) (string-trim '(#\Return) x)) file-lines)))
    (setf *test-node* (plump:parse (apply #'concatenate 'string trimmed-lines)))))


;; (defun find-a-tags (node)
;;   (princ "a")
;;   (let ((tags))
;;     (if (< 0 (length node))
;;         (let ((child-nodes (plump:children node)))
;;           (progn (if (string= "a" (tag-name (elt child-nodes 0)))
;;                      (progn (princ "Found a!~%")
;;                             (cons (elt child-nodes 0) tags)))
;;                  (find-a-tags (subseq child-nodes 1)))))
;;     tags))

;; (defun iterate-children (node)
;;   (labels ((proc-node (node)
;;              (when node
;;                ;; (format t "Node: ~a~%" node)
;;                (cond ((has-child-nodes node) (loop for n across (children node)
;;                                                    do (proc-node n))
;;                       (and (a-tag-p node) (text-node-p node)) (format t "found a: ~a~a~%" (text node) (type-of node))
;;                       ;; (text-node-p node) (text node)
;;                       )))
;;              ))
;;     (proc-node node)))

;; (defun iterate-children2 (node)
;;   (labels ((proc-node (node)
;;              (when node
;;                ;; (format t "Node: ~a~%" node)
;;                (cond ((has-child-nodes node) (loop for n across (children node)
;;                                                    do (proc-node n))
;;                       (and (a-tag-p node) (text-node-p node)) node
;;                       ;; (text-node-p node) (text node)
;;                       )))
;;              ))
;;     (format t "~a~%" (proc-node node))))

;; (defun find-a-tags (node)
;;   (labels ((proc-node (node)
;;              (when node
;;                (when (a-tag-p node)
;;                  (format t "Found a: ~a~%" (text node)))
;;                (when (has-child-nodes node)
;;                  (loop for n across (children node)
;;                        do (proc-node n))))))
;;     (proc-node node)))

(defun find-a-tags (node)
  (let ((tags))
    (labels ((proc-node (node)
               (when node
                 (when (a-tag-p node)
                   (push node tags))
                 (when (has-child-nodes node)
                   (loop for n across (children node)
                         do (proc-node n))))))
      (proc-node node))
    tags))

(defun a-tag-p (node)
  (when (and (not (eq 'root (type-of node)))
             (not (eq 'text-node (type-of node))))
    (string= "a" (tag-name node))))

(defun tag= (node tag-string)
  "Returns T if tag-string equals nodes tag-name, or if tag-string equals *"
  (when (and (not (eq 'root (type-of node)))
             (not (eq 'text-node (type-of node))))
    (if (string= "*" tag-string)
      T
      (string= tag-string (tag-name node)))))

(defun attribute-contains-value (node attribute value)
  (let ((attribute-value (attribute node attribute)))
    (when attribute-value
      (if (search value attribute-value)
          t
          nil))))

(defmacro has-attributes (node &rest attributes)
  `(and (has-attribute ,node ,@attributes)))

;; concats list of strings into string
;; (apply #'concatenate 'string *file-contents-in-list*)

;; trims all strings in list
;; (mapcar #'(lambda (x) (string-trim '(#\Return) x) ) *file-contents-in-list*)

;; combo of above two
;; (apply #'concatenate 'string (mapcar #'(lambda (x) (string-trim '(#\Return) x) ) *file-contents-in-list*))

;; trim strings in list, concats into string and parses into plump document 
;; (plump:parse (apply #'concatenate 'string (mapcar #'(lambda (x) (string-trim '(#\Return) x) ) *file-contents-in-list*)))
