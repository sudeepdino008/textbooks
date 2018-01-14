
;; 1.16

(define (iter-expo b n)
  (define (even? n) (= 0 (remainder n 2)))
  (define (recurse b n a)
	(cond ((= n 0) a)
		  ((even? n) (recurse (* b b) (/ n 2) a))
		  (else (recurse b (- n 1) (* a b)))))
  (recurse b n 1))

(iter-expo 3 34)
