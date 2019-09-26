
(setq *print-case* :capitalize)

;;(defparameter *kibiras* 'Kiauras)

;;(format t "~d ~%"
;;    (equal *kibiras* 'Kiaurass))

(defvar *kojos* 2)

(if 
    (= *kojos* 8) 
    (format t "Astunkojis ~%") 
    (format t "Kazkoks neaiskus ~%"))

(if 
    (not 
        (= *kojos* 8)) 
    (format t "Kojos nelygu kojom ~%") 
    (format t "Visos kojos lygios ~%"))

(if 
    (and 
        (<= *kojos* 3) 
        (>= *kojos* 0))
    (format t "Mazoka koju ~%")
    (format t "Pakankamas kiekis koju"))

(if 
    (or 
        (<= *kojos* 3) 
        (>= *kojos* 0))
    (format t "Vienap ar kitaip yra koju ~%")
    (format t "Vienap ar kitaip yra koju ~%"))