
(define (for-each proc lis)
  (cond ((null? lis) (newline))
		(else (let () (proc (car lis)) (for-each proc (cdr lis))))
		)
  )

(for-each (lambda (x)
			(newline)
			(display x))
		  (list  2 3 4 6))
