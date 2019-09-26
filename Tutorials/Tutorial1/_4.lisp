
(setq *print-case* :capitalize)

(loop for x from 1 to 15
do
    (format t "Desra #~d ~%" x))

(setq x 1)

(loop
    (format t "~d!~%" x)
    (setq x
        (+ x 1))
    (when         
        (> x 33) 
        (return x))
)

(loop for desra in '
    (Popierine Veganiska Suns) do
    (format t "Desros pobudis: ~s ~%" desra)
)

(dotimes 
    (time 3)
    (print time))