(define (fringe x)
  (if (pair? x)
      (append (fringe (car x)) (fringe (cdr x)))
      (if (null? x)
          x
          (list x))))

(define x (list (list 1 2) (list 3 4)))

(fringe x)
(fringe (list x x))

      
          
