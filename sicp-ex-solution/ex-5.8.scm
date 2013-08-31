;; Exercise 5.8
(define (make-label-entry label-name insts)
  (cons label-name insts))

(define (exists-label? labels label-name)
  (let ((val (assoc label-name labels)))
    (if val
        true
        false)))

(define (extract-labels text receive)
  (if (null? text)
      (receive '() '())
      (extract-labels (cdr text)
       (lambda (insts labels)
         (let ((next-inst (car text)))
           (if (symbol? next-inst)
               (receive insts
                        (if (exists-label? labels next-inst)
                            (error "Label already exists: " next-inst)
                            (cons (make-label-entry next-inst
                                                    insts)
                                  labels)))
               (receive (cons (make-instruction next-inst)
                              insts)
                        labels)))))))

