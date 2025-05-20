(defun line-starting-with-pat (str)
  (beginning-of-buffer)
  (search-forward-regexp str)
  (beginning-of-line)
  (point))

(defun pat-for-verse (c v)
  (format "^%03d:%03d" c v))

(defun pat-for-next-verse ()
    "^[[:digit:]]\\{3\\}:[[:digit:]]\\{3\\}")

(defun start-of-verse (c v)
  (save-excursion
    (beginning-of-buffer)
    (search-forward-regexp (pat-for-verse c v))
    (beginning-of-line)
    (point)))

(defun end-of-verse (c v)
  (save-excursion
    (beginning-of-buffer)
    (search-forward-regexp (pat-for-verse c v))
    (search-forward-regexp (pat-for-next-verse) nil "continue")
    (beginning-of-line)
    (point)))

(defun insert-verse (b c v)
 (insert-verses b c v c v))
  
(defun insert-verses (b sc sv ec ev)
  (let* ((dest-buf (current-buffer))
         (src-buf (generate-new-buffer "btext")))
    (with-current-buffer src-buf
      (insert-file-contents (format "%s.txt" b))
      (insert-into-buffer
       dest-buf
       (start-of-verse sc sv)
       (end-of-verse ec ev)))))
