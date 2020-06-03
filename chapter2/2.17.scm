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




(define lis (list 1 2 3 4))

(define (last-pair lis)
  (cond ((null? lis) nil)
	  ((null? (cdr lis)) (car lis))
	  (else (last-pair (cdr lis)))
	  )
  )

(define (last-pair2 lis)
  (cond ((null? lis) nil)
		(else "ww")
		)
  )

(last-pair (list 1))

(car lis)
(cdr lis)







