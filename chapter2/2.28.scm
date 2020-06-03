

(define (fringe lis)
  (cond ((null? lis) ())
		((not (list? lis)) (display lis) (display "\t"))
		(else (fringe (car lis)) (fringe (cdr lis)))
		)
  )

(fringe ())
(fringe (list 1 (list 3 4 5) 3))

(null? ())

