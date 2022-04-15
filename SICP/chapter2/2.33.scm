(define (accumulate op initial sequence)
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


(map (lambda (x) (* x x)) (list 1 2 3))




;;;
(define (append seq1 seq2)
  (accumulate cons seq1 seq2)
  )

(append (list 1 2 3) (list 3 4 5))


;;;
(define (length sequence)
  (accumulate (lambda (x y) (+ 1 y)) 0 sequence)
  )

(length (list 1 2 3 4 44))




(RESTART 1)
