
(define (fast-prime? n)
  (define (even? n) (= 0 (remainder n 2)))
  (define (sq n) (* n n))
  (define (expo a n m)
	(cond ((= n 0) (remainder 1 m))
		  ((even? n) (remainder (sq (expo a (/ n 2) m)) m))
		  (else (remainder (* a (expo a (- n 1) m)) m))))

  (define (fermat-test? a n)
	(= (remainder a n) (remainder (expo a n n) n)))
	
  (define (iterate n iter)
	(cond ((= iter 0) #t)
		  ((fermat-test? (+ 1 (random (- n 1))) n) (iterate n (- iter 1)))
		  (else #f)))

  (iterate n 10))

(fast-prime? 97)
