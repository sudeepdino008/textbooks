
;;stalled

(while ((i 1) (j 2)) (some bool value) (updates)
       (body)
       )


(initialization)
(check-condition)

(body)
(updates)
(check-condition)

(body)
(updates)
(check-condition)


(define (while-variables exp) ....)
(define (while-initial-values exp) ....)

(define (check-condition exp) ...)


(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body))
  )

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



(while ((i 1) (j 2)) (and (< i 10) (< j 2)) ((set! i 3) (set! j (+ j 1)))
       (body)
       )


(make-begin
 (convert-initialiazation-assignments)
 (and-then-eval-assignment)

 (make-let (assignments) (condition)


(eval-assignment exp1)
(eval-assignment exp2)
(check exp1)
(make-lambda-combination
 (make-lambda variables body)
 expressions)


