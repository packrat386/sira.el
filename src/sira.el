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
         (src-buf (get-buffer-create "btext")))
    (with-current-buffer src-buf
      (insert-file-contents (sira--book-file b))
      (insert-into-buffer
       dest-buf
       (sira--start-of-verse sc sv)
       (sira--end-of-verse ec ev)))))

(defun sira--pat-for-next-chapter ()
  "^[[:digit:]]\\{3\\}:001")

(defun sira--pat-for-begin-chapter (c)
  (format "^%03d:001" c))

(defun sira--start-of-chapter (c)
  (save-excursion
    (beginning-of-buffer)
    (search-forward-regexp (sira--pat-for-begin-chapter c))
    (beginning-of-line)
    (point)))

(defun sira--end-of-chapter (c)
  (save-excursion
    (beginning-of-buffer)
    (search-forward-regexp (sira--pat-for-begin-chapter c))
    (search-forward-regexp (sira--pat-for-next-chapter) nil "continue")
    (beginning-of-line)
    (point)))

(defun sira--insert-chapter (b c)
 (sira--insert-chapters b c c))

(defun sira--insert-chapters (b sc ec)
  (let* ((dest-buf (current-buffer))
         (src-buf (get-buffer-create "btext")))
    (with-current-buffer src-buf
      (insert-file-contents (sira--book-file b))
      (insert-into-buffer
       dest-buf
       (sira--start-of-chapter sc)
       (sira--end-of-chapter ec)))))

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

(defun sira--normalize-book-name (b)
  (string-replace " " "_" (downcase b)))

(defun sira-insert-passage (passage)
  "Insert the given bible passage at the current point"
  (interactive
   (list (read-string "passage: ")))
  (cond
    ((string-match
      (rx bol (group-n 1 (opt (+ digit) (+ space)) (+ alpha)) (+ space) (group-n 2 (+ digit)) eol)
      passage)
     (let ((b (sira--normalize-book-name (match-string 1 passage)))
           (c (string-to-number (match-string 2 passage))))
       (sira--insert-chapter b c)))
    ((string-match
      (rx bol (group-n 1 (opt (+ digit) (+ space)) (+ alpha)) (+ space) (group-n 2 (+ digit)) ":" (group-n 3 (+ digit)) eol)
      passage)
     (let ((b (sira--normalize-book-name (match-string 1 passage)))
           (c (string-to-number (match-string 2 passage)))
           (v (string-to-number (match-string 3 passage))))
       (sira--insert-verse b c v)))
    ((string-match
      (rx bol (group-n 1 (opt (+ digit) (+ space)) (+ alpha)) (+ space) (group-n 2 (+ digit)) ":" (group-n 3 (+ digit)) "-" (group-n 4 (+ digit)) eol)
      passage)
     (let ((b (sira--normalize-book-name (match-string 1 passage)))
           (c (string-to-number (match-string 2 passage)))
           (bv (string-to-number (match-string 3 passage)))
           (ev (string-to-number (match-string 4 passage))))
       (sira--insert-verses b c bv c ev)))
    (t (error "unrecognized passage format"))))

(defun sira-open-passage (passage)
  "Open the given bible passage in a new buffer"
  (interactive
   (list (read-string "passage: ")))
  (let ((outbuf (get-buffer-create "sira")))
    (with-current-buffer outbuf
      (let ((inhibit-read-only t))
        (erase-buffer)
        (sira-insert-passage passage)
        (read-only-mode)))
    (pop-to-buffer outbuf)))

(defun sira-open-book (bname)
  "Open the given bible book in a new buffer"
  (interactive
   (list (read-string "book: ")))
  (let ((outbuf (get-buffer-create "sira")))
    (with-current-buffer outbuf
      (let ((inhibit-read-only t))
        (erase-buffer)
        (insert-file-contents (sira--book-file (sira--normalize-book-name bname)))
        (read-only-mode)))
    (pop-to-buffer outbuf)))

(provide 'sira)
