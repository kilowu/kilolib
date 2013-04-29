(define (deep-reverse items)
  (let ((tail-part (cdr items)))
    (if (null? tail-part)
        items
        (append (deep-reverse tail-part)
                (if (pair? (car items))
                    (list (deep-reverse (car items)))
                    (list (car items)))))))


(define list1 (list (list 0 (list 1 -1)) 2 (list 3 4) 5))
(deep-reverse list1)

                          
