(define (accumulate op initial sequence)
  (display sequence)
  (newline)
  (if (null? sequence)
	  initial
	  (op (car sequence)
		  (accumulate op initial (cdr sequence))
		  )
	  )
  )




(define (map p sequence)
  (accumulate (lambda (x y)
				(append (list (p x)) y))
			  '() sequence)
  )

(define (enumerate tree)
  (display tree)
  (newline)
  (cond ((null? tree) '())
		((not (pair? tree)) (list tree))
		(else (append (enumerate (car tree)) (enumerate (cdr tree))))
		)
  )


(define (count-leaves t)
;  (display t)
 ; (newline)
  (accumulate + 0 (map (lambda (x)
						 (cond (not (pair? x) 1))
						 (else (count-leaves x)))
					   t)
			  )
  )


(define tree (list 1 (list 2 3) (list (list 2 3 4) 4 (list 5 6))))
(count-leaves tree)

(RESTART 1)

