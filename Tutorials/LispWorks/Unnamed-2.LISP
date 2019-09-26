;
; Recipes
; from Lisp in Small Parts, http://lisp.plasticki.com/
; Licensed under CC0 1.0: http://creativecommons.org/publicdomain/zero/1.0/
; 13th June 2012
;

(defparameter ingredient-database '("eggs" "flour" "butter" "chicken" "beef" "pork" "lamb" "sugar" "chocolate" "onions" "fish" "tomatoes" "pasta" "chorizo" "rice" "potatoes" "cheese"))

(defparameter recipe-database nil)

; Useful procedures

(defun contains (item list)
  (if (null list) nil
    (if (string= item (first list)) t
      (contains item (rest list)))))

(defun subset (lista listb)
  (if (null lista) t
    (if (null (contains (first lista) listb))
        nil
      (subset (rest lista) listb))))

; Only include recipes that only need specified ingredients

(defun recipes-can-make (ingredients recipes)
  (if (null recipes) nil
    (let* ((entry (first recipes))
           (needs (second entry)))
      (if (subset needs ingredients)
          (cons entry (recipes-can-make ingredients (rest recipes)))
        (recipes-can-make ingredients (rest recipes))))))

; This function adds a recipe to the database

(defun add-recipe ()
  (let ((name (capi:prompt-for-string "What's the recipe?"))
        (ingredients (capi:prompt-for-items-from-list
                      ingredient-database 
                      "What does it need?"))
        (method (capi:prompt-for-string "Brief method:")))
    (setq recipe-database (cons (list name ingredients method) recipe-database))))

; Find a recipe recipe

(defun find-recipe ()
  (let ((ingredients (capi:prompt-for-items-from-list 
                      (sort ingredient-database #'string<) 
                      "What ingredients do you have?")))
    (capi:prompt-with-list
     (recipes-can-make ingredients recipe-database) 
     "You can make these:")))

; Saves them to the file

(defun save-recipes ()
  (with-open-file (stream "Recipes" :direction :output :if-exists :supersede)
    (write ingredient-database :stream stream)
    (write recipe-database :stream stream)))

; Read them from a file

(defun load-recipes ()
  (with-open-file (stream "Recipes" :direction :input)
    (setf ingredient-database (read stream))
    (setf recipe-database (read stream))))
