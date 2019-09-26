
(setq *print-case* :capitalize)

(defparameter *ponai*
'
    (
        (Ponas 
            (Obas Babobas))
        (Ponaitis 
            (Abubas Babubas))
        (Ponulis 
            (Pumpulis Ampinulis))
)
)

(format t "Ponas info: ~a~%" 
    (assoc 'ponas *ponai*))