(define (last-pair lis)
  (define (length li)
	(if (null? li)
		0
		(+ 1 (length (cdr li)))
		)
	)

  (define (last-pair-internal li remaining-length)
	(if (= remaining-length 1)
		(car li)
		(last-pair-internal (cdr li) (- remaining-length 1))
		)
	)

  (last-pair-internal lis (length lis))
  
  )


(last-pair (list 1 2 3 90 22))
