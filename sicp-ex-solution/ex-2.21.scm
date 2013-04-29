(define test-data (list 1 2 3 4))
; first definition
(define (square-list items)
  (if (null? items)
      ()
      (cons (expt (car items) 2) (square-list (cdr items)))))

(square-list test-data)

; second definition
(define (square-list items)
  (map (lambda (x) (expt x 2)) items))

(square-list test-data)
