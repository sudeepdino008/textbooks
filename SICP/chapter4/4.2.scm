a) application? will evaluate (define p 2) as true, and get stuck in loop.


b)

(define (application? exp)
  (and (pair? exp)
       (eq? (car exp) 'call)
       (pair? (cdr exp))))


(define (operator exp)
  (cadr exp)
  )

(define (operand exp) (cddr exp))

similarly, no-operand, rest-operant, first-operand and last-operand

