;;1.2
(define num (+ 5
			   4
			   (- 2
				  (- 3
					 (+ 6
						(/ 4
						   5))))))

(define den (* 3
			   (- 6 2)
			   (- 2 7)))

(define answer (/ num den))
answer
