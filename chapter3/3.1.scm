(define (make-accumulator value)
  (lambda (another-val)
	(set! value (+ value another-val))
	value
	)
  )

(define A (make-accumulator 5))
(A 10)




