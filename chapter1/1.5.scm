
;;1.5

;;applicative order gets stucks in infinite loop. the way things execute normally

(define (p) (p))

(define (test x y)
  (if (= x 0)
	  0
	  y))

(test 0 (p))
