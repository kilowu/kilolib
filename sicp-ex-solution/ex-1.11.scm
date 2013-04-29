(define (f n)
  (if (< n 3)
      n
      (+ (f (- n 1))
         (* 2 (f (- n 2)))
         (* 3 (f (- n 3))))))

(f 1)
(f 2)
(f 3)
(f 4)
(f 23)
      
(define (f-i n)
  (define (f-iter i n1 n2 n3)
    (if (> i n)
        n1
        (f-iter (+ i 1) 
                (+ ni
                   (* n2 2)
                   (* n3 3))
                n1 
                n2)))
  (if (< n 3)
      n
      (f-iter 3 3 2 1)))
  
(f 1)
(f 2)
(f 3)
(f 4)
(f 23)
