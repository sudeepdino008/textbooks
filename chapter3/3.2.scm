(define (make-monittored f)
  (let ((count 0))
	(define (how-many-calls?) count)
	(define (reset-count) (set! count 0))

	(define (count-and-call . args)
	  (set! count (+ 1 count))
	  (apply f args)
	  )

	(define (dispatch m)
	  (cond ((eq? m 'how-many-calls?) (how-many-calls?))
			((eq? m 'reset-count) (reset-count))
			(else (count-and-call m)))
	  )
	
	dispatch)
  )

(define s (make-monittored sqrt))

(s 100)
(s 121)

(s 'reset-count)
(s 'how-many-calls?)
