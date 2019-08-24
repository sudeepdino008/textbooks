
(define (product-recursive a b next-term function)
  (cond ((> a b) 1)
		(else (* (function a) (product-recursive (next-term a) b next-term function) ))))


(define (product-iterative a b next-term function)
  (define (inner a b next-term function result)
	(cond ((> a b) result)
		  (else (inner (next-term a) b next-term function (* result (function a))))))

  (inner a b next-term function 1))

;;factorial

(define (factorial n)
  (define (next-term x) (+ x 1))
  (define (identity-function x) x)
  (product-recursive 1 n next-term identity-function))


(factorial 5)

;; define pi/4 approximation
(define (pi-4-approximation n product)
  (define (next-term x) (+ x 1))
  (define (even? x) (= (remainder x 2) 0))
  (define (numerator x)
	(cond ((even? x) (+ x 2))
		  (else (+ x 1))))
  (define (denominator x)
	(cond ((even? x) (+ x 1))
		  (else (+ x 2))))
  (define (function x)
	(/ (numerator x) (denominator x)))

  (product 1 n next-term function))


;;recursive process
(define (pi-4-approximation-recursive n)
  (pi-4-approximation n product-recursive))
  
(pi-4-approximation-recursive 100)

;;iterative process
(define (pi-4-approximation-iterative n)
  (pi-4-approximation n product-iterative))

(pi-4-approximation-iterative 100)
