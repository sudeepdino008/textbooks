
; russian peasant method
;a*b+c = constant across stages = answer 
;(a,b,c) -> (a/2, 2*b, c) if a is even
;        -> (a-1, b, c+b) if a is odd

(define (mult-iter a b)
  (define (even? a) (= 0 (remainder a 2)))
  (define (double a) (* a 2))
  (define (half a) (/ a 2))
  (define (recurse a b c)
	(cond ((= a 0) c)
		  ((even? a) (recurse (half a) (double b) c))
		  (else (recurse (- a 1) b (+ c b)))))
  (recurse a b 0))

(mult-iter 37498374982374 234278382379837)
