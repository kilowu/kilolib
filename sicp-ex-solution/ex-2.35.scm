(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define nil ())

(define (enumerate-tree tree)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (list tree))
        (else (append (enumerate-tree (car tree))
                      (enumerate-tree (cdr tree))))))

(define (count-leaves t)
  (accumulate + 
              0
              (map (lambda (x) (cond ((null? x) 0)
                                     ((pair? x) (count-leaves x))
                                     (else 1))) t)))

(count-leaves (list 1 (list 2 3) 5))

