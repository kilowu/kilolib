(define (square-tree x)
  (if (pair? x)
      (cons (square-tree (car x)) (square-tree (cdr x)))
      (if (null? x)
          x
          (square x))))

(square-tree
 (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))

(define (square-tree items)
  (map (lambda (x)
         (if (pair? x)
             (square-tree x)
             (square x)))
       items))

(square-tree
 (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))

      
