(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
        ((if? exp) (eval-if exp env))
        ((lambda? exp) (make-procedure (lambda-parameters exp) (lambda-body exp) env))
        ((begin? exp) (eval-sequence (begin-actions exp) env))
        ((cond? exp) (eval (cond->if exp) env))
        ((application? exp) (apply (eval (operator exp) env) (list-of-values (operands exp) env)))
        (else (error "Unknown expression type: EVAL" exp))))



;; solution


(define (and? exp)
  (tagged-list? exp 'and)
  )

(define (and-parameters exp)
  (cddr exp)
  )



(define (and-eval exp env)
  (define (internal-and-eval parameters env)
    (cond ((eq? (cdr parameters) 'nil) (eval (car parameter) env))
          ((not (eval (car parameter) env)) #f)
          (else (internal-and-eval (cdr parameters env)))
    )
    )
  )


(apply + (list 2 5))
