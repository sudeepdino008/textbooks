;; limited precision means for very small numbers good-enough might be difficult to implement.
;; for a larege number x, we need to calculate x^2 order number in good-enough, that might cause overflow 

(define (abs x)
  (if (< x 0) (- x) x))

(define (good-enough? x guess)
  (< (abs (- (* guess guess) x)) 0.01))

(define (average x y)
  (/ (+ x y) 2))

(define (improve-guess x guess)
  (average guess (/ x guess)))

(define (sqrt-with-guess x guess)
  (if (good-enough? x guess)
	  guess
	  (sqrt-with-guess x (improve-guess x guess))))

(define (sqrt x)
  (sqrt-with-guess x 1.0))


;(good-enough? (improve-guess 1.5 2) 2)

;(improve-guess 1.5 2)

;(good

(sqrt 100000000111111111111111111394)

;(abs 4)





