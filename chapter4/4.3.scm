;; dispatching on type

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


;; data-directed dispatch

;; check? is suppose to be comprehensive, i.e. it should not depend on truth/false-hood of earlier other check? implementations.

;; quoted
(define install-module
  (define check? quoted?)
  (define (execute exp env) (test-of-quotation exp))

  (put 'check? '(quoted) check?)
  (put 'execute '(quoted) execute)
  )


(define (eval exp env)
  (define (get-execute-procedure tag-list)
    (cond ((null? tag-list) (error "not found"))
          (((get 'check? (car tag-list)) exp) (get 'execute (car tag-list)))
          (else (get-execute (cdr tag-list))))
    )
  )

