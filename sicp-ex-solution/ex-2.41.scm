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

;; from ex-2.40
(define (unique-pairs n)
  (flatmap (lambda (x) (map (lambda (i) (list i x))
                            (enumerate-interval 1 x)))
           (enumerate-interval 1 n)))
             
(define (unique-triples n)
  (flatmap (lambda (i) (map (lambda (j) (cons i j))
                                (unique-pairs i)))
           (enumerate-interval 1 n)))

(unique-triples 3)

(define (triples-sum-equal n s)
  (filter (lambda (x) (= s
                         (accumulate + 0 x)))
          (unique-triples n)))

(triples-sum-equal 3 7)
         
