(define (last-pair l) 
  (let ((tail (cdr l)))
    (if (null? tail)
        l
        (last-pair tail)
        )))

(last-pair (list 4 2 3 1 3))

