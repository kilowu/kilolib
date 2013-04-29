(define (same-parity first . args)
  (define (iter rest)
    (if (null? rest)
        ()
        (if (= (modulo first 2)
               (modulo (car rest) 2))
            (append (list (car rest)) (iter (cdr rest)))
            (iter (cdr rest)))))
  (cons first (iter args)))

(same-parity 2 2 3 4 5 6 7)

            
  
      
