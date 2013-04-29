(define (for-each pro items)
  (if (null? (map pro items))
      't
      't))

(for-each (lambda (x) (newline) (display x))
          (list 57 321 88))

            
