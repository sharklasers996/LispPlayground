(defparameter *test-xpath* "//table//div/a/img")

(defun count-occurrences (search-string input)
  "Counts search-string occurrences in input"
  (let* ((count 0)
        (index (search search-string input))
        (next-index (when index
                      (1+ index))))
    (when next-index
      (incf count)
      (incf count (count-occurrences search-string (subseq input next-index))))
    count))

(defun find-indices (search-string input &optional (start-from 0))
  "Returns a list of indices of search-string in input"
  (let* ((indices (list))
         (index (search search-string input :start2 start-from))
         (next-index (when index
                       (1+ index))))
    (when next-index
      (push index indices)
      (setf indices (append indices (find-indices search-string input next-index))))
    indices))

(defun find-index-pairs (search-string input)
  (let* ((result (list))
        (indices (find-indices search-string input)))
    (labels ((take-two (lst)
               (when (<= 2 (length lst))
                 (push (list (first lst) (second lst)) result)
                 (take-two (cddr lst)))))
      (when (not (evenp (length indices)))
        (error "Index count is not even"))
      (take-two indices))
    (reverse result)))
