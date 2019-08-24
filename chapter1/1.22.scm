;; runtime doesn't give proper values for small values of n

(define (prime? n)
  (define (smallest-divisor n)
	(define (_smallest-divisor n i)
	  (cond ((> (* i i) n) n)
			((= 0 (remainder n i)) i)
			(else (_smallest-divisor n (+ i 1)))))
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



; 100000000003***.46999999999999886
(timed-prime-test 100000000003)
; 1000000000039***1.4500000000000028
(timed-prime-test 1000000000039)


; 1e11
; 100000000003***.5100000000000051
; 100000000019***.4000000000000057
; 100000000057***.4000000000000057
(loop-primes 100000000000 100000000057)

; 1e12
; 1000000000039***1.2999999999999972
; 1000000000061***1.309999999999988
; 1000000000063***1.2900000000000063
(loop-primes 1000000000000 1000000000063)





