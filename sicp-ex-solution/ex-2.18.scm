(define (reverse items)
  (let ((tail-part (cdr items)))
    (if (null? tail-part)
        items
        (append (reverse tail-part)
              (list (car items))))))

(define list1 (list 1 2 3 4 5))
(reverse list1)

                          
