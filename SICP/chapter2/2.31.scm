(define (map-tree proc tree)
  (let ()
	(display tree)
	(newline)
	(cond ((null? tree) '())
		  ((not (pair? tree)) (proc tree))
		  (else (cons (map-tree proc (car tree))
					  (map-tree proc (cdr tree))
					  )
				)
	)
	)
  )

(define square (lambda (x) (* x x)))
(define (square-tree tree) (map-tree square tree))


(define tree (list (list 1 3 (list 2 3))
				   (list 3 4 2) 7))

(square-tree tree)
