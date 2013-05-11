(define (equal? a b)
  (cond ((and (pair? a) (pair? b)) (and (equal? (car a) (car b))
                                        (equal? (cdr a) (cdr b))))
        ((or (pair? a) (pair? b)) false)
        (else (eq? a b))))

(equal? '(1 2 3 (4 5) 6) '(1 2 3 (4 5) 6)) 
(equal? '(1 2 3 (4 5) 6) '(1 2 3 (4 5 7) 6))

        
         
