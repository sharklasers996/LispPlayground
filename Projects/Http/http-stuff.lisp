(defvar *page-source* (dex:get "https://www.imdb.com/title/tt1190634/?ref_=fn_al_tt_1"))

(defvar *parsed-page* (plump:parse *page-source*))
