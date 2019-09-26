(ql:quickload '("dexador" :plump :lquery))

(require "dexador")
(require :plump)
(require :lquery)

(defpackage :cl-imdb
  (:use :common-lisp)
  (:use :cl-user)
  (:use :dexador)
  (:use :plump)
  (:use :lquery))

(in-package #:cl-imdb)

(defun vector-to-trimmed-string (vector)
  (string-trim '(#\Space #\Newline #\Tab) (vector-pop vector)))

(defun get-title (parsed-page)
  (vector-to-trimmed-string (lquery:$ parsed-page ".title_wrapper h1" (text))))

(defun get-rating (parsed-page)
  (list :rating (vector-to-trimmed-string ($ parsed-page ".ratingValue > strong:nth-child(1) > span:nth-child(1)" (text)))
        :vote-count (vector-to-trimmed-string ($ parsed-page "span.small" (text)))))

(defun get-description (parsed-page)
  (vector-to-trimmed-string ($ parsed-page ".summary_text" (text))))

(defun get-seasons (parsed-page)
  (let ((seasons))
    (labels ((get-season (season-nodes)
               (if season-nodes
                   (progn (push (list (text (aref season-nodes 0))
                                      (concatenate 'string "https://imdb.com" (attribute (aref season-nodes 0) "href"))) seasons)
                          (if (< 1 (length season-nodes))
                              (get-season (subseq season-nodes 1))
                              seasons))
                   seasons)))
      (get-season ($ parsed-page ".seasons-and-year-nav > div:nth-child(4) > a"))
      (remove-if-not (lambda (s) (if (parse-integer (first s) :junk-allowed T) T nil)) seasons))))

(defun get-season-count (seasons)
  (first (first (last seasons))))

(defun get-genres (parsed-page)
  (remove-if-not (lambda (x) (if (search "(" x) nil T))($ parsed-page ".subtext > a" (text))))

(defun get-main-actors (parsed-page)
  (remove-if-not (lambda (x) (if (search "full cast" x) nil T))($ parsed-page "div.credit_summary_item:nth-child(3) > a" (text))))

(defvar *source* nil)
(defvar *page* nil)

(defun setup-page ()
  (setf *source* (dex:get "https://www.imdb.com/title/tt0462538/?ref_=tt_sims_tt"))
  (setf *page* (plump:parse *source*)))
