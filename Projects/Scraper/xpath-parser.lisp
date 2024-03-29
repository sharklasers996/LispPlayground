(defparameter *test-xpath* "/html/div/a")
(defparameter *xpath-tokens* nil)

(defun set-xpath (xpath)
  (setf *test-xpath* xpath)
  (set-xpath-tokens))

(defun set-xpath-tokens ()
  (setf *xpath-tokens* nil)
  (dolist (x (split-xpath *test-xpath*)) (push (parse-xpath-token x) *xpath-tokens*)))

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
  "Same as find-indices, but returns indices as a list of pairs"
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


(defun remove-intersecting-indices (indices index-pairs)
  "Removes from indices where item falls between an index-pair"
  (dolist (i index-pairs)
    (setf indices (remove-if #'(lambda(x) (and (< (first i) x) (> (second i) x))) indices)))
  indices)


(defun remove-neighboring-indices (indices)
  "Removes numbers from list which have a (1- i) member
  (0 2 3 5 7 8) => (0 2 5 7)"
  (let ((result-indices (list)))
        (dolist (i indices)
          (when (not (member (1- i) result-indices))
            (push i result-indices)))
    (reverse result-indices)))


(defun split-xpath (xpath)
  "Splits xpath into a list of single element tokens"
  (let* ((result (list))
        (slash-indices (find-indices "/" xpath))
        (quote-index-pairs (find-index-pairs "'" xpath))
        (not-ignored-slash-indices (remove-intersecting-indices slash-indices quote-index-pairs))
        (non-neighboring-indices (remove-neighboring-indices not-ignored-slash-indices))
        (current-index nil)
        (next-index nil))
    (dotimes (i (length non-neighboring-indices))
      (setf current-index (pop non-neighboring-indices))
      (when (< 0 (length non-neighboring-indices))
        (setf next-index (first non-neighboring-indices)))
      (if next-index
          (push (subseq xpath current-index next-index) result)
          (push (subseq xpath current-index) result))
      (setf next-index nil))
    result))

(defun parse-xpath-token (xpath-token)
  (let* ((properties-index (search "[" xpath-token))
        (unparsed-tag-string (if properties-index
                                 (subseq xpath-token 0 properties-index)
                                 xpath-token))
         (tag-name-index (1+ (search "/" unparsed-tag-string :from-end t)))
         (token (list :tag-name (subseq unparsed-tag-string tag-name-index)
                      :first-child (if (= tag-name-index 1)
                                       t
                                       nil)
                      :properties (if properties-index
                                      (subseq xpath-token properties-index)))))
    token))
