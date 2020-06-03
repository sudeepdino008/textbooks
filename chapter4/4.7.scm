(define (lambda? exp) (tagged-list? exp 'lambda))
(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))


(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body))
  )

;;(let ((var1 exp1)
;;      (var2 exp2)
;;      ...
;;      )
;;  (body)
;;  )



;;((lambda (var1 var2 var3) (body)) exp1 exp2 exp3)


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

(let-expressions '(let ((var1 exp1) (var2 exp2)) (body)))

(cdr (cons 'lambda-cha '(ee rr)))

(define (make-lambda-combination lambda-dec expressions)
  (cons lambda-dec expressions)
  )

(define (let->combination exp)
  (make-lambda-combination
   (make-lambda (let-variables exp) (let-body exp))
   (let-expressions exp))
  )


;;(let* ((var1 exp1) (var2 exp2)...) (body))
;;=>
;;(let ((var1 exp1))
;;  (let ((var2 exp2))
;;    (let ((var3 exp3))
;;      (body)
;;      )))

(define (make-let assignments body)
  (cons 'let (cons assignments (list body)))
  )

(define (let-assignments exp) (cadr exp))

(make-let '((var1 exp1) (var2 exp2)) '(body))

(define (let*->nested-lets exp)
  (define (internal assignments body)
    (if (eq? assignments '()) (car body)
        (make-let (list (car assignments))
                  (internal (cdr assignments) body))
        )
    )

  (internal (let-assignments exp) (let-body exp))
  )

(let*->nested-lets '(let* ((var1 exp1) (var2 exp2) (var3 exp3)) (body)))
