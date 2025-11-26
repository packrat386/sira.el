(defun sira--line-starting-with-pat (str)
  (beginning-of-buffer)
  (search-forward-regexp str)
  (beginning-of-line)
  (point))

(defun sira--pat-for-verse (c v)
  (format "^%03d:%03d" c v))

(defun sira--pat-for-next-verse ()
    "^[[:digit:]]\\{3\\}:[[:digit:]]\\{3\\}")

(defun sira--start-of-verse (c v)
  (save-excursion
    (beginning-of-buffer)
    (search-forward-regexp (sira--pat-for-verse c v))
    (beginning-of-line)
    (point)))

(defun sira--end-of-verse (c v)
  (save-excursion
    (beginning-of-buffer)
    (search-forward-regexp (sira--pat-for-verse c v))
    (search-forward-regexp (sira--pat-for-next-verse) nil "continue")
    (beginning-of-line)
    (point)))

(defun sira--insert-verse (b c v)
 (sira--insert-verses b c v c v))
  
(defun sira--insert-verses (b sc sv ec ev)
  (let* ((dest-buf (current-buffer))
         (src-buf (generate-new-buffer "btext")))
    (with-current-buffer src-buf
      (insert-file-contents (sira--book-file b))
      (insert-into-buffer
       dest-buf
       (sira--start-of-verse sc sv)
       (sira--end-of-verse ec ev)))))

(defun sira--package-dir ()
  (let ((pkg-desc (package-get-descriptor 'sira)))
    (if
     pkg-desc
     (package-desc-dir pkg-desc))))

(defun sira--book-file (bname)
  (let ((pkg-dir (sira--package-dir))
        (env-dir (getenv "SIRA_DATA_DIR"))
        (fname (format "%s.txt" bname)))
    (cond
      (pkg-dir (file-name-concat pkg-dir "data" fname))
      (env-dir (file-name-concat env-dir fname))
      (t fname))))
               
(provide 'sira)
