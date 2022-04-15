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


(define tree (list (list 1 3 (list 2 3))
				   (list 3 4 2) 7))

(map-tree (lambda (x) (* x x)) tree)



;;; rough stuff
(display tree)
(cdr tree)

(cons (list 3) '())

(pair? (list 2))
(cons 1 ())
(list? (list 3))
(null? (cdr (list 7)))
(pair? (list 3))
(list 'nil (list 2 3))
(list 'nil (list 2))

(null? (car (list 1)))


(car (list 3 2))

(RESTART 1)
