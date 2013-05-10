(define (make-accumulator initial)
  (let ((sum initial))
    (lambda (num)
      (begin (set! sum (+ num sum)) sum))))

(define a1 (make-accumulator 10))
(define a2 (make-accumulator 5))

(a1 1)
(a2 2)
(a1 2)
(a2 1)
