(define (even? t) (= (remainder t 2) 0))

(define (cons a b)
  (define (square t) (* t t))
  (define (exp x y)
	(cond ((= y 0) 1)
		  ((even? y) (square (exp x (/ y 2))))
		  (else (* x (exp x (- y 1))))
		  )
	)

  (* (exp 2 a)
	 (exp 3 b)
	 )
  )


(define p (cons 3 4))

(define (car x)
  (define (by2 y count)
	 (cond ((even? y) (by2 (/ y 2) (+ count 1)))
		   (else count)
		   )
	 )

  (by2 x 0)
  )

(define (cdr x)
  (define (by3 y count)
	(cond ((= (remainder y 3) 0) (by3 (/ y 3) (+ count 1)))
		  (else count)
		  )
	)
  (by3 x 0)
  )


(car p)
(cdr p)


