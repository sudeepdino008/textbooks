(define (deep-reverse lis)
  (cond ((null? lis) (list))
		((not (list? lis)) lis)
		(else (append (deep-reverse (cdr lis)) (list (deep-reverse (car lis)))))
		)
  )

(deep-reverse (list 1 (list 2 3) 44 (list 4) 99 (list 5 8 9)))
