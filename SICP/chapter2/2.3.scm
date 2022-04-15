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



(define (rectangle point side1 side2)
  (cons point (cons side1 side2))
  )


(define (sides rect)
  (define (first-side)
	(car (cdr rect))
	)

  (define (second-side)
	(cdr (cdr rect))
	)

  (cons (first-side) (second-side))
  )

(define (perimeter rect)
  (let ((a (car (sides rect)))
		(b (cdr (sides rect)))
		)
	(* 2 (+ a b))
	)
  )

(define (area rect)
  (let (
		(a (car (sides rect)))
		(b (cdr (sides rect)))
		)
	(* a b)
	)
  )
		
		 
	   
(define rect1 (rectangle (make-point 2 3) 2 4))

(perimeter rect1)
(area rect1)

