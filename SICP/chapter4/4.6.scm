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



(let->combination '(let ((var1 (exp1)) (var2 (exp2))) (body)))
(let->combination '(let ((var1 (exp1 exp2))) (body)))
