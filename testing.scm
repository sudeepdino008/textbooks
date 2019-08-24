(define size
  (+
   (* 3
	  (- 3 2))
   1)
  )


(define (abs x)
  (cond ((< x 0) (- x))
		(else x)))

(abs 4)


(define (abs-if x)
  (if (< x 0) (- x) x))

(abs-if -9)



(define (f x y)
  (let ((a
		 (+ 1 (* x y)))
		(b
		 (- 1 y))
		)
	(+ (* x a a) (* y b) (* a b))
	)
  )

(define (ff x y)
  ((lambda (a b) (+ (* x a a) (* y b) (* a b)))
   (+ 1 (* x y))
   (- 1 y)
   )
  )

(ff 2 1)


(define x (cons 1 2))

(car x)
(cdr x)


(list 1 2 3 4)
