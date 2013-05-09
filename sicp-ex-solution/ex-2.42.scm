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

;; Auxiliary routine
(define (all seq)
  (if (null? seq)
      't
      (and (car seq)
           (all (cdr seq)))))

;; Solution goes here
(define empty-board ())

(define (safe? k positions)
  (let ((crow (car (car positions)))
        (ccol (cdr (car positions))))
    (all (map (lambda (pos)
                (let ((col (cdr pos))
                      (row (car pos)))
                  (and (not (= row crow)) 
                       (not (= (abs (- row crow))
                               (abs (- col k)))))))
              (cdr positions)))))

; Test data from problem example set
(define test-data (list (cons 3 8)
                        (cons 7 7)
                        (cons 2 6)
                        (cons 8 5)
                        (cons 5 4)
                        (cons 1 3)
                        (cons 4 2)
                        (cons 6 1)))
; test safe?
(safe? 8 test-data)
(safe? 2 (list (cons 1 1) (cons 2 2)))
             
; The position number of column is counted from right to left.
(define (adjoin-position new-row k rest-of-queens)
  (if (null? rest-of-queens)
      (list (cons new-row k))
      (cons (cons new-row k) rest-of-queens)))
; test adjoin-position
(adjoin-position 2 2 (list (cons 1 1)))
                
;; Problem procedure
(define (queens board-size)
  (define (queen-cols k)  
    (if (= k 0)
        (list empty-board)
        (filter
         (lambda (positions) (safe? k positions))
         (flatmap
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position new-row k rest-of-queens))
                 (enumerate-interval 1 board-size)))
          (queen-cols (- k 1))))))
  (queen-cols board-size))

;; Test
(queens 1)
(queens 2)
(queens 3)
(queens 4)
(queens 5)
(queens 8)
