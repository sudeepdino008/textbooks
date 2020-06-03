(define (map-lis proc lis)
  (cond ((null? lis) '())
		(else
		 (cons 
		  (proc (car lis))
		  (map-lis proc (cdr lis))
		  )
		 )
		)
  )


(define (subsets s)
  (display s)
  (newline)
  (if (null? s) (list '())
	  (let ((rest (subsets (cdr s))))
		(display rest)
		(newline)
		(append rest (map-lis (lambda (rest_elem) (append rest_elem (list (car s)))) rest)
				)
		)
	  )
  )


(subsets (list 1 2 3))


(list '())
