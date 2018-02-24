;; runtime doesn't give proper values for small values of n

(define (prime? n)

  (define (next n)
	(cond ((= n 2) 3)
		  (else (+ n 2))))
  
  (define (smallest-divisor n)
	(define (_smallest-divisor n i)
	  (cond ((> (* i i) n) n)
			((= 0 (remainder n i)) i)
			(else (_smallest-divisor n (next i)))))

	(_smallest-divisor n 2))
  
  (= n (smallest-divisor n)))


(define (timed-prime-test n)
  (define (start-prime-test n start-time)
	(define (report-prime elapsed-time)
	  (display n)
	  (display "***")
	  (display elapsed-time)
	  (newline))
	
	(if (prime? n)
		(report-prime (- (runtime) start-time))))
  
  (start-prime-test n (runtime)))



(define (loop-primes start end)
  (define (iterate i n)
	(cond ((> i n) ())
		  (else (timed-prime-test i)
				(iterate (+ i 1) n))))

  (iterate start end))
		  


;;results 

;
(timed-prime-test 100000000003)
;
(timed-prime-test 1000000000039)



; 100000000003***.3499999999999943
; 100000000019***.2600000000000051
; 100000000057***.25
(loop-primes 100000000000 100000000057)



; 1000000000039***.8299999999999983
; 1000000000061***.8200000000000074
; 1000000000063***.7999999999999972
(loop-primes 1000000000000 1000000000063)
