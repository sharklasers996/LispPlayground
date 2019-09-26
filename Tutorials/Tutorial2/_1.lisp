(defun square (x)
  (* x x))

(defun opa ()
  (print "desra!"))

(defun triangular (x)
  (* x (/ (+ x 1) 2))
)

(opa)

; Combine lists
(defvar *combined* (cons 1 '(1 2 3)))
(defvar *combined2* (cons '(1 2) '(1 2 3)))
(defvar *combined3* (cons 1 2))

(print *combined*)
(print *combined2*)
(print *combined3*)

; Join lists
(defvar *joined* (append '(1 2) '(3 4)))

(print *joined*)

; first - first in list
; rest - all but first in list

(defun swap (list)
  (append 
    (append 
      (list (first (rest list)))
      (list (first list))
    )
    (rest (rest list))
  )
)
(terpri)

(format t "Swapped: ~d~%" (swap '(9 8 7 6)))

(defun dup (list)
  (append
    (list (first list))
    list
  )
)

(terpri)

(print (dup '(1 2 3 4)))

(defun random-element (list)
  (let* 
    ((r (length list)))
    (print (random 4))
    (nth r list)
  )
)

(print (random-element '(1 2 3 4)))


; Concat strings

(print (concatenate 'string "a" "b" "c"))

; Substring

(print (subseq "averylongword" 5 9))

(terpri)
(format t "1: ~a 2: ~a" 'desra 'bybis)

; Calling function

(defun apply-list (function items)
  (if (null items) nil
    (progn
      (funcall function (first items))
      (apply-list function (rest items)))))

(apply-list 'print '(2 3 4 5 6 opa ?))