(define (same-parity lis)
  (define (equal-parity? num parity)
	(= (remainder num 2) parity)
	)
  (define (itr lis parity)
	(cond ((null? lis) (list))
		  ((equal-parity? (car lis) parity) (append (itr (cdr lis) parity) (list (car lis))))
		  (else (append (itr (cdr lis) parity) (list)))
	)
	)

  (itr lis (remainder (car lis) 2))
  )

(define input (list 4 2 3 4 5 56 88))
(same-parity input)







