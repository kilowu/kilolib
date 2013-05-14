;; Must retain ordered property, so the unordered version
;; is not suitable for this task.
(define (adjoin-set x set)
  (cond ((null? set) '(x))
        ((= x (car set)) set)
        ((< x (car set)) (cons x set))
        (else (cons (car set)
                    (adjoin-set x (cdr set))))))

(adjoin-set 4 '(1 2 3 5))
(adjoin-set 1 '(1 2 3 5))
         
