
(setq *print-case* :capitalize)

(defun hello
    ()
    (print "Hello")
    (terpri))

(hello)

(defun get-avg 
    (num1 num2) 
    (/ 
        (+ num1 num2) 2)
)

(format t "Avg 3 & 45 = ~a~%" 
    (get-avg 3 45))

; ---------------------------------------------------------------

(defvar *total* 0)

(defun sum 
    (&rest nums)  ; &rest converts value to a list
    (dolist 
        (num nums)
        (setf *total* 
            (+ *total* num))        
)
    (format t "Sum = ~a~%" *total*)
)

(sum 1 2 3 4 5)

; ---------------------------------------------------------------

(defun difference 
    (num1 num2)
    (return-from difference
        (- num1 num2))
)

(format t "10 - 2 = ~a~%" 
    (difference 10 2))

; ---------------------------------------------------------------

(defparameter *ponai*
'
    (
        (Ponas 
            (Obas Babobas) 
            (15 ordinu))
        (Ponaitis 
            (Abubas Babubas)
            (11 ordinu))
        (Ponulis 
            (Pumpulis Ampinulis)
            (13 ordinu))
)
)

(defun get-ponas-data 
    (ponas)
    (format t "~a~%"
`
        (, 
            (caar ponas) yra ,
            (cadar ponas) su ,
            (cddar ponas)))
)

(get-ponas-data *ponai*)

; ---------------------------------------------------------------

(format t "A number ~a~%" 
    (mapcar #'numberp `
        (1 2 3 a b c)))

; ---------------------------------------------------------------

(flet 
    (
        (double-it 
            (num)
            (* num 2))
        (triple-it 
            (num) 
            (* num 3))
        (format t "Double & Triple 10 = ~d~%" 
            (triple-it
                (double-it
                    (10)))))
)

; ---------------------------------------------------------------

;00:47