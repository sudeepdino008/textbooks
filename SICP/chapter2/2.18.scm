(define (reverse lis)
  (if (null? (cdr lis))
	  (list (car lis))
	  (append (reverse (cdr lis)) (list (car lis)))
	  )
  )

(reverse (list 1 2 3 45 90))





;; way 2
(define (reverse lis)
  (cond ((null? lis) (list))
		(else (append (reverse (cdr lis)) (list (car lis))))
		)
  )

(reverse lis)

