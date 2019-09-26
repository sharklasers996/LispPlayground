(defpackage #:cl-imdb
  (:use :cl-user)
  (:import-from :dexador
   :plump
   :lquery)
  (:export #:get-title
           #:get-rating
           #:get-description
           #:get-seasons
           #:get-season-count
           #:get-genres
           #:get-main-actors
           #:setup-page))

(in-package #:cl-imdb)
