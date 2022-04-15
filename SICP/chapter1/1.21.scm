
(define (smallest-divisor n)
  (define (_smallest-divisor n i)
	(cond ((> (* i i) n) n)
		  ((= 0 (remainder n i)) i)
		  (else (_smallest-divisor n (+ i 1)))))
  (_smallest-divisor n 2))

(smallest-divisor 199)
(smallest-divisor 1999)
(smallest-divisor 19999)


		
	  
