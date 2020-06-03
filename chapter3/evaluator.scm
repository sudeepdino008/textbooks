;; metacircular evaluator from sicp

;; support for delayed streams (no memoization)
;; analyze style evaluation


(define (debug . args)
  (define (loop stuff)
    (cond ((eq? stuff '()) (newline))
          (else (begin 
                  (display (car stuff))
                  (display " ")
                  (loop (cdr stuff))
                  #t
                  ))))
  ;;#t
  ;;(loop args)
  )

(define apply-in-underlying-scheme apply)

(define (let? exp) (tagged-list? exp 'let))

(define (let-variables exp)
  (define (internal lis)
    (if (null? lis) '()
        (cons (caar lis) (internal (cdr lis)))
        )
    )

  (internal (cadr exp))
  )

(define (let-body exp)
  (cddr exp))

(define (let-expressions exp)
  (define (internal lis)
    (if (null? lis) '()
        (cons (cadar lis) (internal (cdr lis))))
    )

  (internal (cadr exp))
  )

(define (make-lambda-combination lambda-dec expressions)
  (cons lambda-dec expressions)
  )

(define (let->combination exp)
  (make-lambda-combination
   (make-lambda (let-variables exp) (let-body exp))
   (let-expressions exp))
  )


(define (self-evaluating? exp)
  (or (number? exp) (string? exp)))

(define (variable? exp)
  (symbol? exp))

(define (quoted? exp)
  (tagged-list? exp 'quote))

(define (text-of-quotation exp) (cadr exp))

(define (tagged-list? exp tag)
  (if (pair? exp)
    (eq? (car exp) tag)
    #f))

(define (assignment? exp)
  (tagged-list? exp 'set!))

(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))

(define (definition? exp)
  (tagged-list? exp 'define))

(define (define-variable exp)
  (if (symbol? (cadr exp))
    (cadr exp)
    (caadr exp)))

(define (define-value exp)
  (if (symbol? (cadr exp))
    (caddr exp)
    (make-lambda (cdadr exp)
                 (cddr exp))))

(define (lambda? exp) (tagged-list? exp 'lambda))
(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))

(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))

(define (if? exp) (tagged-list? exp 'if))
(define (if-predicate exp) (cadr exp))
(define (if-consequent exp) (caddr exp))
(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
    (cadddr exp)
    'false))

(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))

(define (begin? exp) (tagged-list? exp 'begin))
(define (begin-actions exp) (cdr exp))
(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exp seq) (cdr seq))

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))

(define (make-begin seq) (cons 'begin seq))

(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

(define (cond? exp) (tagged-list? exp 'cond))
(define (cond-clauses exp) (cdr exp))
(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))
(define (cond-predicate clause) (car clause))
(define (cond-actions clause) (cdr clause))
(define (cond->if exp) (expand-clauses (cond-clauses exp)))
(define (expand-clauses clauses)
  (if (null? clauses)
    'false
    (let ((first (car clauses))
          (rest (cdr clauses)))
      (if (cond-else-clause? first)
        (if (null? rest)
          (sequence->exp (cond-actions first))
          (error ("ELSE clause isn't last -- COND->IF" clauses)))
        (make-if (cond-predicate first)
                 (sequence->exp (cond-actions first))
                 (expand-clauses rest))))))

(define (true? x)
  (not (false? x)))

(define (false? x)
  (eq? x #f))

;; procedure related functions

(define (make-procedure parameters body env)
  (list 'procedure parameters body env))

(define (compound-procedure? p)
  (tagged-list? p 'procedure))

(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))

;; stream related functions
(define (cons-stream? exp) (tagged-list? exp 'cons-stream))
(define (stream-car exp) (cadr exp))
(define (stream-cdr exp) (make-lambda '() (cddr exp)))

(define (stream-car? exp) (tagged-list? exp 'stream-car))
(define (stream-cdr? exp) (tagged-list? exp 'stream-cdr))

(define (cons-stream->cons exp)
  (list 'cons (stream-car exp) (stream-cdr exp)))


;; environment realted functions

(define (enclosing-environment env) (cdr env))
(define (first-frame env) (car env))

(define the-empty-environment '())

(define (make-frame variables values)
  (cons variables values))

(define (frame-variables frame) (car frame))
(define (frame-values frame) (cdr frame))

(define (add-binding-to-frame! var val frame)
  (set-car! frame (cons var (car frame)))
  (set-cdr! frame (cons val (cdr frame))))

(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
    (cons (make-frame vars vals) base-env)
    (if (< (length vars) (length vals))
      (error "Too many arguments supplied")
      (error "Too few arguments supplied"))))

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

(define (set-variable-value! var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
      (error "Unbound variable -- SET!" var)
      (let ((frame (first-frame env)))
        (scan (frame-variables frame)
              (frame-values frame)))))
  (env-loop env))

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond ((null? vars)
             (add-binding-to-frame! var val frame))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (scan (frame-variables frame)
          (frame-values frame))))

(define (eval exp env) ((analyze exp) env))

(define (analyze exp)
  ;;(debug "in analyze:" exp)
  (cond ((self-evaluating? exp) (analyze-self-evaluating exp))
        ((variable? exp) (analyze-variable exp))
        ((quoted? exp) (analyze-quoted exp))
        ((assignment? exp) (analyze-assignment exp))
        ((definition? exp) (analyze-definition exp))
        ((if? exp) (analyze-if exp))
        ((let? exp) (analyze (let->combination exp)))
        ((cons-stream? exp) (analyze (cons-stream->cons exp)))
        ((stream-cdr? exp) (analyze-stream-cdr exp))
        ((stream-car? exp) (analyze-stream-car exp))
        ((lambda? exp) (analyze-lambda exp))
        ((begin? exp) (analyze-sequence (begin-actions exp)))
        ((cond? exp)  (analyze (cond->if exp)))
        ((application? exp) (analyze-application exp))
        (else
          (error "Unknown expression type -- EVAL" exp))))

;;(define (car/stream-cdr-body exp) (cadr exp))
(define (stream-car-arguments exp) (cadr exp))
(define (analyze-stream-car exp)
  (let ((body (analyze (stream-car-arguments exp))))
    ;;(display body)
    (lambda (env) (car (body env)))
    ))

(define (analyze-stream-cdr exp)
  (let ((body (analyze (stream-car-arguments exp))))
    (lambda (env)
      ;;(display body)
      (execute-application (cdr (body env)) '())
      )
    )
  )

(define (analyze-if exp)
  (let ((predicate (analyze (if-predicate exp)))
        (consequent (analyze (if-consequent exp)))
        (alternative (analyze (if-alternative exp))))
    (lambda (env)
      (if (true? (predicate env)) (consequent env) (alternative env)))
    )
  )

(define (analyze-lambda exp)
  (let ((vars (lambda-parameters exp))
        (bproc (analyze-sequence (lambda-body exp))))
    (lambda (env) (make-procedure vars bproc env))))

(define (analyze-sequence exps)
  (define (sequentially proc1 proc2)
    (lambda (env) (proc1 env) (proc2 env)))
  (define (loop first-proc rest-procs)
    (if (null? rest-procs) first-proc
        (loop (sequentially first-proc (car rest-procs)) (cdr rest-procs))))
  (let ((fexps (if (list? exps) exps (list exps))))
    (let ((procs (map analyze fexps)))
      (if (null? procs)
          (error "Empty sequence: ANALYZE"))
      (loop (car procs) (cdr procs)))))

(define (analyze-application exp)
  (let ((fproc (analyze (operator exp)))
        (aprocs (map analyze (operands exp))))
    (lambda (env)
      (execute-application
       (fproc env)
       (map (lambda (aproc) (aproc env)) aprocs)))))

(define (execute-application proc args)
  (cond ((primitive-procedure? proc) (apply-primitive-procedure proc args))
        ((compound-procedure? proc) ((procedure-body proc)
                                     (extend-environment (procedure-parameters proc) args
                                                         (procedure-environment proc))))
        (else
         (error "Unknown procedure type: EXECUTE-APPLICATION" proc))))

(define (analyze-self-evaluating exp)
  (lambda (env) exp))

(define (analyze-quoted exp)
  (let ((qval (text-of-quotation exp)))
    (lambda (env) qval)))

(define (analyze-variable exp)
  (debug "variable:" exp)
  (lambda (env) (lookup-variable-value exp env))
  )

(define (analyze-assignment exp)
  (let ((right (analyze (assignment-value exp)))
        (var (assignment-variable exp)))
    (lambda (env) 
      (set-variable-value! var (right env) env))
    'ok))

(define (analyze-definition exp)
  (let ((right (analyze (define-value exp)))
        (var (define-variable exp)))
    (lambda (env)
      (define-variable! var (right env) env)
      'ok)
    )
  )

(define (setup-environment)
  (let ((initial-env
          (extend-environment (primitive-procedure-names)
                              (primitive-procedure-objects)
                              the-empty-environment)))
    (define-variable! 'true #t initial-env)
    (define-variable! 'false #f initial-env)
    initial-env))


(define (primitive-procedure? proc) (tagged-list? proc 'primitive))
(define (primitive-implementation proc) (cadr proc))

(define primitive-procedures
  (list (list 'car car)
        (list 'cdr cdr)
        (list 'cons cons)
        (list 'null? null?)
        (list '+ +)
        (list '- -)
        (list '* *)
        (list '/ /)
        (list '> >)
        (list '< <)
        (list '<= <=)
        (list '>= >=)
        (list 'display display)
        (list 'list list)
        (list 'load load)
        (list 'eq? eq?)
        (list 'remainder remainder)
        (list 'trace trace)
        (list '= =)))

(define (primitive-procedure-names)
  (map car primitive-procedures))

(define (primitive-procedure-objects)
  (map (lambda (p) (list 'primitive (cadr p)))
       primitive-procedures))

(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme
    (primitive-implementation proc) args))

(define input-prompt "::> ")

(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output (eval input the-global-environment)))
      (announce-output)
      (user-print output)))
  (driver-loop))

(define (prompt-for-input string)
  (newline) (newline) (display string))

(define (announce-output)
  (newline) (newline))

(define (user-print object)
  (cond ((compound-procedure? object)
         (display (list 'compound-procedure
                        (procedure-parameters object)
                        (procedure-body object)
                        '<procedure-env>)))
        ((not (or (pair? object) (list? object))) (begin (display object) (display " ")))
        (else (begin (display "(") (user-print (car object)) (user-print (cdr object)) (display ")")))))

(define the-global-environment (setup-environment))

;; (trace analyze-lambda)
;; (trace analyze-sequence)
;; (trace analyze)
;; (trace analyze-variable)
;; (trace analyze-stream-car)
;; (trace analyze-stream-cdr)
;; (trace analyze)
;; (trace analyze-application)
;; (trace apply-primitive-procedure)
;; (trace stream-car-arguments)
;; (trace lookup-variable-value)
;; (trace operator)
;; (trace operands)
;;(trace user-print)
(driver-loop)
