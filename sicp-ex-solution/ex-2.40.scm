;; library functions
(define nil ())

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low (enumerate-interval (+ low 1) high))))

;; start
(define (unique-pairs n)
  (flatmap (lambda (x) (map (lambda (i) (list i x))
                            (enumerate-interval 1 x)))
           (enumerate-interval 1 n)))
             
(unique-pairs 4)
