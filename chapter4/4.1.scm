(define (list-of-values exps env)
  (if (no-operands? exps) '()
      (cons (eval (first-operand exps) env)
            (list-of-values (rest-operands exps) env)))
  )



;; left-to-right guaranteed evaluation

(define (list-of-values exps env)
  (if (no-operands? exps) '()
      (let ((first (eval (first-operand exps) env))
            (second (list-of-calues (rest-operands exps) env)))
        (cons first second)
        )
      )
  )


;; for right-to-left evaluation, switch the first and second let evaluations.
