
(setq *print-case* :capitalize)


(defvar *list* '
    (1 2 3))

(push 5 *list*)

(format t "nth ~a~%" 
    (nth 3 *list*))

;---------------------------------------------------------

(defvar kaimiska-desra 
    (list :pavadinimas "Kaimiska" :kokybe "Hujova"))

(defvar *desru-sarasas* nil)

(push kaimiska-desra *desru-sarasas*)

(dolist 
    (desra *desru-sarasas*)
    (format t "~{~a: ~a~%~}" desra)
)
