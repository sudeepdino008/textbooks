
;;1.3
(define (square x) (* x x))
										;(define (sum-of-square x y) (+ (square x) (square y)))

(define (min x y)
  (if (< x y) x y))

(define (max-sum-of-square x y z)
  (-
   (+ (square x) (square y) (square z))
   (square (min (min x y) z))))

(max-sum-of-square 2 3 9)
(max-sum-of-square 2 3 3)
