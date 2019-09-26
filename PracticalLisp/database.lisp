(defvar *db* nil)
(defun add-record (cd) (push cd *db*))

(defun make-cd (title artist rating ripped)
  (list :title title :artist artist :rating rating :ripped ripped))

(defun dump-db ()
  (dolist (cd *db*)
    (format t "~{~a:~10t~a~%~}~%" cd)))


; ~{ ~} Directive one-liner
;
; (defun dump-db ()
;   (format t "~{~{~a:~10t~a~%~}~%~}" *db*))

(defun prompt-read (prompt)
  (format *query-io* "~a: " prompt)
  (force-output *query-io*)
  (read-line *query-io*))

(defun prompt-for-cd ()
  (add-record
   (make-cd
    (prompt-read "Title")
    (prompt-read "Artist")
    (or (parse-integer (prompt-read "Rating") :junk-allowed t) 0) ; :junk-allowed - doesn't throw error if there are numbers in input
    (y-or-n-p "Ripped [y/n]")))
  )

(defun add-cds ()
  (loop (add-record (prompt-for-cd))
        (if (not (y-or-n-p "Another? [y/n]: ")) (return))))

(defun save-db (filename)
  (with-open-file (out filename
                       :direction :output
                       :if-exists :supersede)
    (with-standard-io-syntax
      (print *db* out))))

(defun load-db (filename)
  (with-open-file (in filename)
    (with-standard-io-syntax
      (setf *db* (read in)))))

(defun select-by-artist (artist)
  (remove-if-not
   #'(lambda (cd) (equal (getf cd :artist) artist))
   *db*))

(defun select (selector-fn)
  (remove-if-not selector-fn *db*))

(defun where (&key title artist rating (ripped nil ripped-p))
  #'(lambda (cd)
      (and
       (if title    (equal (getf cd :title)  title)  t)
       (if artist   (equal (getf cd :artist) artist) t)
       (if rating   (equal (getf cd :rating) rating) t)
       (if ripped-p (equal (getf cd :ripped) ripped) t))))

(defun update (selector-fn &key title artist rating (ripped nil ripped-p))
  (setf *db*
        (mapcar
         #'(lambda (row)
             (when (funcall selector-fn row)
               (if title    (setf (getf row :title) title))
               (if artist   (setf (getf row :artist) artist))
               (if rating   (setf (getf row :rating) rating))
               (if ripped-p (setf (getf row :ripped) ripped)))
             row) *db*)))


;;(update (where :artist "Slackers") :rating 10)


(defun delete-rows (selector-fn)
  (setf *db* (remove-if selector-fn *db*)))


(defun make-comparison-expr (field value)
  (list 'equal (list 'getf 'cd field) value))

;; (make-comparison-expr :desra 12)

(defun make-comparisons-list (fields)
  (loop while fields
        collecting (make-comparison-expr (pop fields) (pop fields))))


(defmacro where2 (&rest clauses)
  `#'(lambda (cd) (and ,@(make-comparisons-list clauses))))

;; (macroexpand-1 '(where2 :title "Give Us a Break" :ripped t))


;; http://www.gigamonkeys.com/book/functions.html
;; Functions As Data, a.k.a. Higher-Order Functions




