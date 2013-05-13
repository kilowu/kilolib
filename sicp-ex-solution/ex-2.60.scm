;; Test data
(define data '(e f g g 2 a e))

;; Solution
(define (element-of-set? x set)
  (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))

(element-of-set? 'a data)
(element-of-set? 'z data)

(define (adjoin-set x set)
  (if (null? set)
      (list x)
      (cons x set)))
(adjoin-set 'f data)

(define (intersection-set set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
        ((element-of-set? (car set1) set2)        
         (cons (car set1)
               (intersection-set (cdr set1) set2)))
        (else (intersection-set (cdr set1) set2))))
(intersection-set data '(f g z))

(define (union-set set1 set2)
  (cond ((null? set1) set2)
        ((null? set2) set1)
        (else (union-set (cdr set1) (adjoin-set (car set1) set2)))))
(union-set data '(f g z))


         

