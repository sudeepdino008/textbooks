(define (df)
  (let ((base 1))
	(define (dispatch val)
	  (set! base (* base val))
	  base
	  )
	dispatch)
  )

(define f (df))



(f 0)
(f 1)
