;; Binary tree related operations
(define (entry tree)
  (if (null? tree)
      '()
      (car tree)))

(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))

(define (key rec) 
  (if (null? rec)
      nil
      (car rec)))

(define nil '())

;; Solution
(define (lookup given-key set-of-records)
  (cond ((null? set-of-records) nil)
        ((= given-key (key (entry set-of-records))) (entry set-of-records))
        ((> given-key (key (entry set-of-records)))
         (lookup given-key (right-branch set-of-records)))
        ((< given-key (key (entry set-of-records)))
         (lookup given-key (left-branch set-of-records)))))

(define data '((3 c) ((2 b) ((1 a) () ()) ()) ((4 d) () ())))
(lookup -1 data)
(lookup -5 data)
(lookup 2 data)

