(define (gcd a b)
  (if (= b 0) a
	  (gcd b (remainder a b))
	  )
  )

(gcd 206 40)

;; normal order: 18 remainder calculations

(gcd 206 40)
(gcd 40 (r 206 40))
(gcd (= (r 206 40) 0)...) -> 1
(gcd (= 6 0)...)
(gcd (r 206 40) (r 40 (r 206 40))))
(gcd (= (r 40 (r 206 40)) 0)...) -> 2
(gcd (= 4 0)...)
(gcd (r 40 (r 206 40)) (r (r 206 40) (r 40 (r 206 40))))
(gcd (= (r (r 206 40) (r 40 (r 206 40))) 0)....) -> 4
(gcd (= 2 0)....)
(gcd (r (r 206 40) (r 40 (r 206 40))) (r (r 40 (r 206 40)) (r (r 206 40) (r 40 (r 206 40)))))
(gcd (= (r (r 40 (r 206 40)) (r (r 206 40) (r 40 (r 206 40)))) 0)...) -> 7
(gcd (= (r 4 (r 6 4)))...)
(r (r 206 40) (r 40 (r 206 40))) -> 4



;; applicative order: 4 remainder calculations

(gcd 206 40)
(gcd 40 (r 206 40)) -> 1
(gcd 40 6)
(gcd 6 (r 40 6)) -> 1
(gcd 6 4)
(gcd 4 (r 6 4)) -> 1
(gcd 4 2)
(gcd 2 (r 4 2)) -> 1
(gcd 2 0)

