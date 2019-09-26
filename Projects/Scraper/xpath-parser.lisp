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
    (print "vals")
    (print index)
    (print next-index)
    (when next-index
      (push index indices)
      (setf indices (append indices (find-indices search-string input next-index))))
    indices))
