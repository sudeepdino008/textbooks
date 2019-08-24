(define make-point cons)
(define x-point car)
(define y-point cdr)

(define (make-segment start-segment end-segment)
  (cons start-segment end-segment)
  )

(define start-segment car)
(define end-segment cdr)


(define (midpoint-segment line-segment)

  (define (average val-provider point1 point2)
	(/ (+ (val-provider point1) (val-provider point2)) 2)
	)

  (let ((x-mid (average x-point (start-segment line-segment) (end-segment line-segment)))
		(y-mid (average y-point (start-segment line-segment) (end-segment line-segment)))
		)
	(make-point x-mid y-mid)
	)
  )


(define newsegment (make-segment (make-point 2 3) (make-point 4 2)))

(midpoint-segment newsegment)
