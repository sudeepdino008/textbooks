
(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (cond ((eq? (car vals) '*unassigned*) (error "local variable not yet assigned: " var))
                   (else (car vals))))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
      (error "Unbound variable" var)
      (let ((frame (first-frame env)))
        (scan (frame-variables frame)
              (frame-values frame)))))
  (env-loop env))

;; (lambda ⟨vars⟩
;;   (define u ⟨e1⟩)
;;   (define v ⟨e2⟩)
;;   ⟨e3⟩)

;; would be transformed into

;; (lambda ⟨vars⟩
;;   (let ((u '*unassigned*)
;;         (v '*unassigned*))
;;     (set! u ⟨e1⟩)
;;     (set! v ⟨e2⟩)
;;     ⟨e3⟩))

(define (lambda? exp) (tagged-list? exp 'lambda))
(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))

(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))

(define (make-let declarations body)
  (cons 'let declarations body))

(define (scan-out-defines proc)
  (define (get-defines loop-body)
    (cond ((eq? loop-body '()) '())
          ((definition? (car loop-body)) (cons (car loop-body) (get-defines (cdr loop-body))))
          (else (get-defines (cdr loop-body)))
          )
    )

  (define (get-non-defines loop-body)
    (cond ((eq? loop-body '()) '())
          ((not (definition? (car loop-body))) (cons (car loop-body) (get-non-defines (cdr loop-body))))
          (else (get-non-defines (cdr loop-body)))
          )
    )
  
  (define (get-let-initializations variables)
    (map (lambda (var) (cons var '*unassigned*)) variables)
    )

  ;; ideally the setters should repalce the defines in the exact position, and not be modified to clubbed together at the start of the body.
  (define (get-setters define-declarations)
    (map (lambda (var) (cons 'set! (definition-variable var) (definition-value var))) define-declarations)
    )

  
  (let ((body (caddr proc)))
    (let ((all-the-defines (get-defines body)))
      (let ((all-the-non-defines (get-non-defines body)))
        (make-lambda (lambda-parameters proc)
                     (make-let (get-let-initializations (map definition-variable all-the-defines))
                               (append (get-setters all-the-defines)) all-the-non-defines)
                     )
        )
      )
    )
  )



;; make-procedure is better place. procedure-body is executed again and again, so doing the above operations in it will be inefficient.

(define (make-procedure variables body env)
  (list 'procedure variables (scan-out-defines body)  env)
  )
