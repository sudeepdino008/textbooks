(define (fermat-test? n)
  (define (fast-expo a n m)
	(define (even? n) (= (remainder n 2) 0))
	(define (square n) (* n n))
	(define (recurse a n m)
	  (cond ((= n 0) 1)
			((even? n) (remainder (square (recurse a (/ n 2) m)) m))
			(else (remainder (* a (square (recurse a (/ (- n 1) 2) m))) m))))
	(recurse a n m))

  (define (iter a n)
	(cond ((= a n) true)
		  ((= (fast-expo a n n) a) (iter (+ 1 a) n))
		  (else false)))

  (iter 1 n))

(fermat-test? 1105)
