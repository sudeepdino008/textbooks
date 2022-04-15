(RESTART 1)

(define (enclosing-environment env) (cdr env))
(define (first-frame env) (car env))
(define the-empty-environment '())


(define (aggregate lis initial-value procedure)
  (if (eq? lis '()) initial-value
      (procedure (car lis)
                 (aggregate (cdr lis) initial-value procedure))
      )
  )

(define (two-list-aggregate lis1 lis2 initial-value procedure)
  (if (eq? lis1 '()) initial-value
      (procedure (car lis1) (car lis2)
                 (two-list-aggregate (cdr lis1) (cdr lis2) initial-value procedure))
      )
  )

(define (make-frame variables values)
  ;; assuming variables and values size are same

  (two-list-aggregate variables values '()
                      (lambda (lis1-elem lis2-elem aggregated-elem)
                        (cons (cons lis1-elem lis2-elem) aggregated-elem)
                        )))

 
(define (frame-variables frame)
  (aggregate frame '() (lambda (elem aggregated-elem)
                         (cons (car elem) aggregated-elem)
                         )))

(define (frame-values frame)
  (aggregate frame '() (lambda (elem aggregated-elem)
                         (cons (cdr elem) aggregated-elem)
                         )))


(define (add-binding-to-frame! var val frame)
  (cons (cons var val) frame)
  )


(define (extend-environment vars vals base-env)
  ;; assuming lengths are same
  (cons (make-frame vars vals) (list base-env))
  )



(define (abstract-loop-envs var env procedure)
  (display env)
  (newline)
  (define (loop-frame frame)
    (display "what:")
    (display frame)
    (newline)
    (cond ((eq? frame '()) #f)
          ((eq? (caar frame) var) (procedure (car frame)))
          (else (loop-frame (cdr frame)))))
  
  (cond ((eq? env '()) (error "Unbound variable"))
        (else (let ((value (loop-frame (first-frame env))))
                (cond ((eq? value #f)
                       (abstract-loop-envs var (enclosing-environment env) procedure))
                      (else value)))))
  )


(define (lookup-variable-value var env)
  (abstract-loop-envs var env (lambda (entry) (cdr entry)))
  )

(define (set-variable-value! var val env)
  (abstract-loop-envs var env (lambda (entry) (set-cdr! entry val))))


;; tests
(define frame (make-frame '(var1 var2 var3) '(1 2 3)))


(frame-variables frame)
(frame-values frame)

(add-binding-to-frame! 'var4 5 frame)

(define env1 frame)
(define env2 (extend-environment (list 'var99 'var100) (list 88 89) env1))
env2

(lookup-variable-value 'var12 env2)

(set-variable-value! 'var3 999 env2)
(lookup-variable-value 'var3 env2)
