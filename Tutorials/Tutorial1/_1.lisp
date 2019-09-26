;(format t "Nesveikos desros ~%")

(print "Kaip desros?")

(defvar *desra* (read))

(defun apdesret (*desra*)
    (format t "Desru pobudis: ~a !!!! ~%" *desra*)
)

(setq *print-case* :capitalize)

(apdesret *desra*)


()