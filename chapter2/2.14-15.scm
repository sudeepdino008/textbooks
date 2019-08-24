

(define (make-interval a b) (cons a b))

(define (upper-bound a) (max (car a) (cdr a)))
(define (lower-bound a) (min (car a) (cdr a)))


(define (mul-interval x y)
  (let ((p1 (* (upper-bound x) (upper-bound y)))
		(p2 (* (upper-bound x) (lower-bound y)))
		(p3 (* (lower-bound x) (upper-bound y)))
		(p4 (* (lower-bound x) (lower-bound y))))
	(make-interval (min p1 p2 p3 p4) (max p1 p2 p3 p4))
	)
  )

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

(define (add-interval a b)
  (let ((p1 (+ (lower-bound a) (lower-bound b)))
		(p2 (+ (upper-bound a) (upper-bound b))))
	(make-interval p1 p2)
	)
  )

(define (sub-interval a b)
  (let ((p1 (- (lower-bound a) (upper-bound b)))
		(p2 (- (upper-bound a) (lower-bound b))))
	(make-interval (min p1 p2) (max p1 p2))
	)
	)


(define (make-center-percent c p)
  (make-center-width c (* c p))
  )

(define (percent interval)
  (/ (width interval) (center interval))
  )


(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2) (add-interval r1 r2))
  )



(define (par2 r1 r2)
  (let ((one (make-interval 1 1)))
	(div-interval one (add-interval (div-interval one r1) (div-interval one r2)))
	)
  )


(define r1 (make-interval 3 7))
(define r2 (make-interval 8 10))

(mul-interval r1 r2)
(add-interval r1 r2)


(par1 r1 r2) ;; -> (1.4, 6.3)
(par2 r1 r2) ;; -> (2.18, 4.117)



(div-interval r2 r2);; !=1

;; when calculating (r1r2/(r1+r2)), the variation in the value of say r1 is accounted twice, that is the numerator r1 can be equal to lower bound, while denominator r1 can be equal to upper bound. The variation must be accounted for only once. 
;; for the above reason Eva is right. 


