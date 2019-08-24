
;; 1.8




(define
  (cube-root x)

  
  (define (better-guess y)
	(/ (+ (/ x (* y y))
		  (* 2 y)) 3.0))

  (define (abs y) (if (< y 0) (- y) y))

  (define (abs-diff y z) (abs (- y z)))

  (define (good-enough? guess)
	(< (/ (abs-diff x (* guess guess guess)) x) 0.000001))

  (define (cube-root-with-guess guess)
	(if (good-enough? guess)
		guess
		(cube-root-with-guess (better-guess guess))))
  

  
  (if (= x 0) 0 (cube-root-with-guess 1)))

(cube-root 27)

