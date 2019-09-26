(asdf:defsystem #:cl-imdb
  :depends-on (#:dexador
               #:plump
               #:lquery)
  :components ((:file "package")
               (:file "cl-imdb")))
