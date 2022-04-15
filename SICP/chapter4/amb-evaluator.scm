;; metacircular evaluator from sicp

;; support for cons-stream: delayed streams
;; delay and force support: with memoization
;; analyze style evaluation
;; let* support

;; features to be added: strictness modifiers in functions (Exercise 4.31)


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

(define (amb? exp) (tagged-list? exp 'amb))
(define (amb-choices exp) (cdr exp))


(define (let? exp) (tagged-list? exp 'let))
(define (let*? exp) (tagged-list? exp 'let*))

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

(define (let->combination exp)
  (make-lambda-combination
   (make-lambda (let-variables exp) (let-body exp))
   (let-expressions exp))
  )

(define (make-let expressions body)
  (list 'let expressions body))

(define (let*->nested-lets exp)
  (define (let-assignments exp) (cadr exp))
  (define (internal assignments body)
    (if (eq? assignments '()) (car body)
        (make-let (list (car assignments))
                  (internal (cdr assignments) body))
        )
    )

  (internal (let-assignments exp) (let-body exp))
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

(define (make-lambda-combination lambda-dec expressions)
  (cons lambda-dec expressions)
  )


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
(define (stream-cdr exp) (memoize-exp (caddr exp)))

(define (stream-car? exp) (tagged-list? exp 'stream-car))
(define (stream-cdr? exp) (tagged-list? exp 'stream-cdr))

(define (cons-stream->cons exp)
  (list 'cons (stream-car exp) (stream-cdr exp)))

(define (delay? exp) (tagged-list? exp 'delay))
(define (delay->memo-proc exp)
  (memoize-exp (cadr exp))
  )

(define (memoize-exp exp)
  (define force-exp (make-lambda '() (list exp)))
  (define result-set (list 'set! 'result (list force-exp)))
  (define already-run-set '(set! already-run? true))
  
  (define begin-exp (make-begin (list result-set already-run-set 'result)))
  (define if-exp (make-if 'already-run? 'result begin-exp))
  (define outer-lambda (make-lambda '() (list if-exp)))
  (define let-exp (make-let (list '(already-run? false) '(result false))
                            outer-lambda))
     (debug "delay->memo-proc:" let-exp)
   (debug "delay:if-exp" if-exp)
   (debug "delay:outer-lamda" outer-lambda)
   (debug "delay:force-exp" force-exp)
   (debug "delay:" exp)
   let-exp
  )

(define (force? exp) (tagged-list? exp 'force))
(define (analyze-force exp)
  (let ((aexp (analyze (cadr exp))))
    (lambda (env success fail)
      (success (execute-application (aexp env success fail) '()) fail))))
      
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

(define (set-variable-value! var val env)
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

(define (ambeval exp env success fail) ((analyze exp) env success fail))

(define (analyze exp)
  (debug "in analyze:" exp)
  (cond ((self-evaluating? exp) (analyze-self-evaluating exp))
        ((variable? exp) (analyze-variable exp))
        ((quoted? exp) (analyze-quoted exp))
        ((assignment? exp) (analyze-assignment exp))
        ((definition? exp) (analyze-definition exp))
        ((amb? exp) (analyze-amb exp))
        ((if? exp) (analyze-if exp))
        ((let? exp) (analyze (let->combination exp)))
        ((let*? exp) (analyze (let*->nested-lets exp)))
        ((cons-stream? exp) (analyze (cons-stream->cons exp)))
        ((delay? exp) (analyze (delay->memo-proc exp)))
        ((force? exp) (analyze-force exp))
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
    (lambda (env success fail)
      (success (car (body env success fail)) fail))
    ))

(define (analyze-stream-cdr exp)
  (let ((body (analyze (stream-car-arguments exp))))
    (lambda (env success fail)
      (success (execute-application (cdr (body env)) '()) fail))))

(define (analyze-if exp)
  (let ((predicate (analyze (if-predicate exp)))
        (consequent (analyze (if-consequent exp)))
        (alternative (analyze (if-alternative exp))))
    (lambda (env success fail)
      (predicate env
                 (lambda (pred-val fail2)
                   (if (true? pred-val) (consequent env success fail2)
                       (alternative env success fail2)))
                 fail))))

(define (analyze-lambda exp)
  (let ((vars (lambda-parameters exp))
        (bproc (analyze-sequence (lambda-body exp))))
    (lambda (env success fail)
      (success (make-procedure vars bproc env) fail))))

(define (analyze-sequence exps)
  (define (sequentially proc1 proc2)
    (lambda (env success fail)
      (proc1 env
             (lambda (proc1-val fail2) (proc2 env success fail2))
             fail)))

  (define (loop first-proc rest-procs)
    (if (null? rest-procs) first-proc
        (loop (sequentially first-proc (car rest-procs)) (cdr rest-procs))))
  (let ((fexps (if (list? exps) exps (list exps))))
    (let ((procs (map analyze fexps)))
      (if (null? procs)
          (error "Empty sequence: ANALYZE"))
      (loop (car procs) (cdr procs)))))

(define (analyze-amb exp)
  (let ((cprocs (map analyze (amb-choices exp))))
    (lambda (env success fail)
      (define (try-next choices)
        (debug "herehere" choices)
        (if (null? choices) (begin (debug "null found") (fail))
            ((car choices) env
             (lambda (val fail2)
               (debug "trying new choice in success block")
               (success val fail2))
             (lambda ()
               (debug "trying next")
               (try-next (cdr choices))
               )))
        )
      (try-next cprocs)
      )
    )
  )

(define (analyze-application exp)
  (let ((fproc (analyze (operator exp)))
        (aprocs (map analyze (operands exp))))
    (lambda (env success fail)
      (debug "fproc" fproc ";; aprocs" aprocs ";; exp" exp "op" (operator exp)) 
      (fproc env
             (lambda (proc fail2)
               (get-args aprocs
                         env
                         (lambda (args fail3)
                           (execute-application proc args success fail3)) fail2))
             fail)
      )
    )
  )

(define (get-args aprocs env success fail)
  (if (null? aprocs) (success '() fail)
      ((car aprocs) env
       (lambda (val fail2)
         (get-args
          (cdr aprocs) env
          (lambda (args fail3)
            (success (cons val args) fail3))
           fail2))
       fail))
  )


(define (execute-application proc args success fail)
  (cond ((primitive-procedure? proc) (success (apply-primitive-procedure proc args) fail))
        ((compound-procedure? proc) ((procedure-body proc)
                                     (extend-environment (procedure-parameters proc) args
                                                         (procedure-environment proc))
                                     success fail))
        (else
         (error "Unknown procedure type: EXECUTE-APPLICATION" proc))))

(define (analyze-self-evaluating exp)
  (lambda (env success fail) (success exp fail)))

(define (analyze-quoted exp)
  (let ((qval (text-of-quotation exp)))
    (lambda (env success fail) (success qval fail))))

(define (analyze-variable exp)
  (lambda (env success fail)
    (success (lookup-variable-value exp env) fail))
  )

(define (analyze-assignment exp)
  (let ((right (analyze (assignment-value exp)))
        (var (assignment-variable exp)))
    (lambda (env success fail)
      (right env
             (lambda (right-val fail2)
               (let ((existing-val (lookup-variable var env)))
                 (set-variable-value! var right-val env)
                 (success 'ok
                          (lambda ()
                            (set-variable-value! var existing-val env)
                            (fail2)))))
             fail))))

(define (analyze-definition exp)
  (let ((right (analyze (define-value exp)))
        (var (define-variable exp)))
    (lambda (env success fail)
      (right env
             (lambda (right-val fail2)
               (display "assigning")
               (define-variable! var right-val env)
               (success 'ok fail2))
             (lambda ()
               (display "fail in analyze-definition")
               (fail))))))

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
        (list 'not not)
        (list '= =)))

(define (primitive-procedure-names)
  (map car primitive-procedures))

(define (primitive-procedure-objects)
  (map (lambda (p) (list 'primitive (cadr p)))
       primitive-procedures))

(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme
    (primitive-implementation proc) args))

(define input-prompt "Amb-Eval In ::> ")
(define output-prompt "Amb-Eval Out ::> ")

(define (driver-loop)
  (define (internal-loop try-again)
    (prompt-for-input input-prompt)
    (let ((input (read)))
      (if (eq? input 'try-again) (try-again)
          (begin
            (newline) (display ";;; Starting a new problem")
            (ambeval input the-global-environment
                     ;;ambeval success
                     (lambda (val next-alternative)
                       (announce-output output-prompt)
                       (user-print val)
                       (internal-loop next-alternative))
                     ;;ambeval fail
                     (lambda ()
                       (announce-output ";;; There are no more values for:")
                       (user-print input)
                       (driver-loop)))))))

  (internal-loop
   (lambda ()
     (newline) (display ";;; there is no current problem")
     (driver-loop)
     ))
  )

(define (prompt-for-input string)
  (newline) (newline) (display string))

(define (announce-output str)
  (newline) (display str) (newline))

(define (user-print object)
  (cond ((compound-procedure? object)
         (display (list 'compound-procedure
                        (procedure-parameters object)
                        (procedure-body object)
                        '<procedure-env>)))
        ((not (or (pair? object) (list? object))) (begin (display object) (display " ")))
        (else
         (begin
           (display "(")
           (user-print (car object))
           (if (not (eq? (cdr object) '())) (user-print (cdr object)))
           (display ")")))))

(define the-global-environment (setup-environment))

;; (trace analyze-lambda)
;; (trace analyze-sequence)
;; (trace analyze)
;; (trace analyze-variable)
;; (trace analyze-stream-car)
;; (trace analyze-stream-cdr)
;; (trace analyze)
;;  (trace analyze-application)
;;  (trace execute-application)
;; (trace apply-primitive-procedure)
;; (trace analyze-self-evaluating)
;; (trace analyze-amb)
;; (trace make-procedure)
;; (trace stream-car-arguments)
;;  (trace lookup-variable-value)
;;  (trace analyze-force)
;;  (trace delay?)
;; (trace delay->memo-proc)
;;(trace stream-cdr)
(driver-loop)
