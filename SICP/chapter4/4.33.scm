
(define (list-ref lis n)
  (if (= n 0) (car lis)
      (list-ref (cdr lis) (- n 1))))



(car '(a b c))


;; the evaluator changes are done in lazy-evalutor.scm:

(define (list-of-quote exp) (cadr exp))
(define (quoted-list? exp)
  (and (tagged-list? exp 'quote) (pair? (list-of-quote exp))))
(define (list-of-quotation exp env)
  (define (get-delayed-list lis env)
    (if (eq? lis '()) '()
        (cons (delay-it (list 'quote (car lis)) env) (get-delayed-list (cdr lis) env))))
  (get-delayed-list (list-of-quote exp) env)
  )

(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted-list? exp) (list-of-quotation exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
        ((if? exp) (eval-if exp env))
        ((lambda? exp)
         (make-procedure (lambda-parameters exp)
                         (lambda-body exp)
                         env))
        ((begin? exp)
         (eval-sequence (begin-actions exp) env))
        ((cond? exp)  (eval (cond->if exp) env))
        ((application? exp)
         (apply (actual-value (operator exp) env)
                (operands exp) env))
        (else
          (error "Unknown expression type -- EVAL" exp))))
