;; Exercise 5.4
;; Simulated machine code in the book is not listed here.

;; Iterative exp
(define expt-machine
  (make-machine
   '(n b product)
   (list (list '= =) (list '- -) (list '* *))
   '((assign product (const 1))
     test-n
     (test (op =) (reg n) (const 0))
     (branch (label done))
     (assign n (op -) (reg n) (const 1))
     (assign product (op *) (reg b) (reg product))
     (goto (label test-n))
     done)))

;; Recursive exp
(define expt-machine-r
  (make-machine
   '(b n product continue)
   (list (list '= =) (list '- -) (list '* *))
   '((assign continue (label done))
     test-n
     (test (op =) (reg n) (const 0))
     (branch (label stop-case))
     (assign n (op -) (reg n) (const 1))
     (save continue)
     (assign continue (label after-exp))
     (goto (label test-n))
     after-exp
     (restore continue)
     (assign product (op *) (reg b) (reg product))
     (goto (reg continue))
     stop-case
     (assign product (const 1))
     (goto (reg continue))
     done)))

;; Testing procedures
(define (test-machine machine)
  (begin (set-register-contents! machine 'b 2)
         (set-register-contents! machine 'n 4)
         (start machine)
         (display (get-register-contents machine 'product))
         (display "\n")))
(test-machine expt-machine)
(test-machine expt-machine-r)
