
(setq *print-case* :capitalize)

(defvar *lempa* 5)

(defun get-lempa     
    (lempa)
    (case lempa
        (2            
            (print "dvi lempos"))
        (3             
            (print "trys lempos"))
        (otherwise             
            (print "bbz")))
)

(get-lempa *lempa*)

(cond 
   ((>= *lempa* 5) (format t "sauja lempu"))
   (( < *lempa* 5) (format t "mazai lempu"))
   (t (format t "nan")))

