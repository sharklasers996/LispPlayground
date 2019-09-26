(format t "floating points~%")

(format t "~$~%" 3.145)

(format t "~5$~%" 3.1456678)

(terpri)
(terpri)

(format t "v directive~%")
(format t "~v$~%" 1 3.1345)

(terpri)
(terpri)
(format t "d directive output decimals~%")

(format t "~d~%" 1000000)

(format t "~:d~%" 1000000)
(format t "~@d~%" 1000000)

(terpri)
(terpri)

(format t "The value is: ~a~%" 10)          
(format t "The value is: ~a~%" "foo")       
(format t "The value is: ~a~%" (list 1 2 3))

(format t "conditional formatting~%")

(format t "~[cero~;uno~;dos~]~%" 0)
(format t "~[cero~;uno~;dos~]~%" 1)
(format t "~[cero~;uno~;dos~]~%" 2)

(terpri)

(format t "defining format string~%")

(defparameter *list-etc*
  "~#[NONE~;~a~;~a and ~a~:;~a, ~a~]~#[~; and ~a~:;, ~a, etc~].~%")

(format t *list-etc*)               
(format t *list-etc* 'a)            
(format t *list-etc* 'a 'b)         
(format t *list-etc* 'a 'b 'c)      
(format t *list-etc* 'a 'b 'c 'd)   
(format t *list-etc* 'a 'b 'c 'd 'e)


