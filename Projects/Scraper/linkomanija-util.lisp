(ql:quickload '("dexador" :plump :lquery))

(defvar *cookie-jar* (cl-cookie:make-cookie-jar))
(defvar *login-page* nil)

(defun login (username password)
  (dex:post "https://www.linkomanija.net/takelogin.php" :content `(("username" . ,username) ("password" . ,password) ("commit" . "Prisijungti")) :cookie-jar *cookie-jar*))

(defun logged-in-p (page)
  (if (eq nil (search "RonnieRehab" page))
      nil
      T))

(defun get-tv-show-page (page cookie-jar)
  (let ((url (concatenate 'string "https://www.linkomanija.net/browse.php?c30=1&c60=1&page=" (write-to-string page))))
    (format t "Getting page ~a~%" url)
    (dex:get url  :cookie-jar cookie-jar)))


(defvar *tv-show-page-source* (get-tv-show-page 0 *cookie-jar*))
(defvar *tv-show-page* (plump:parse *tv-show-page-source*))

(defmacro query-tv-show-page (query &rest actions)
  `(lquery:$ *tv-show-page* ,query ,@actions))



(defun write-tv-show-page-to-file ()
  (with-open-file (str "l.html"
                       :external-format :utf-8
                       :direction :output
                       :if-does-not-exist :create)
    (format str "~a%" *tv-show-page-source*)))
