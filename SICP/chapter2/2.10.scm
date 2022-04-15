(define (make-interval a b) (cons a b))

(define (upper-bound a) (max (car a) (cdr a)))
(define (lower-bound a) (min (car a) (cdr a)))


(define (div-interval x y)
  (define (width t)
	(- (upper-bound t) (lower-bound t)
	   )
	)
  (define (width0? t)
	(= (width t) 0)
	)

  (cond ((width0? y) (error "0 width not allowed"))
		(else (mul-interval x
				(make-interval (/ 1.0 (upper-bound y))
							   (/ 1.0 (lower-bound y))
							   )
				)
			  )
		)
  )


(div-interval (make-interval 2 3) (make-interval 3 3))





