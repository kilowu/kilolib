(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define nil ())

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op 
                        init 
                        (map car seqs))
            (accumulate-n op 
                          init 
                          (map cdr seqs)))))

(define (dot-product v w)
  (accumulate + 0 (map * v w)))

(define (matrix-*-vector m v)
  (map (lambda (x) (dot-product x v))  m))

(define (transpose mat)
  (accumulate-n cons nil mat))

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (x) (matrix-*-vector cols x)) m)))

(define matrix (list (list 1 1) (list 2 2) (list 3 3)))
(define matrix-2 (list (list 1 1) (list 2 2)))
(define vector (list 2 2))

(list 1)
(matrix-*-vector matrix vector)
(transpose matrix)
(matrix-*-matrix matrix matrix-2)
