
(define (printable-thunk object)
  (cond ((eq? object '()) '())
        ((and (pair? object) (thunk? (car object)))
         (cons (list 'thunk (thunk-exp (car object)) '<thunk-env>)
               (printable-thunk (cdr object))))
        (else (cons (car object) (printable-thunk (cdr object)))))
  )
  

(define (user-print object)
  (cond ((compound-procedure? object)
         (display (list 'compound-procedure
                        (procedure-parameters object)
                        (procedure-body object)
                        '<procedure-env>)))
        ((pair? object) (display (printable-thunk object)))
        (else (display object))))
