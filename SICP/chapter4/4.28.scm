;; any example where the operator is a thunk, serves as a valid example


(define (f x) x)
(define v (f f))
(v 5)

;; using actual-value
;; ((application? exp)
;;          (apply (actual-value (operator exp) env)
;;                 (operands exp) env))

;; 5 (success)

;; using eval
;; ((application? exp)
;;          (apply (eval (operator exp) env)
;;                 (operands exp) env))

;;;Unknown procedure type -- APPLY #0=(thunk f #1=(((v f false true car ...) #0# (procedure (x) (x) #1#) #f #t ...)))
