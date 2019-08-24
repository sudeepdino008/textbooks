(define (make-rat x y)
  (if (< y 0)
	  (make-rat (- x) (- y))
	  (cons x y))
  )


(make-rat -2 -3)
	  
