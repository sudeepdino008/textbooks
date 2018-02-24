
(define (accumulate-recursive combiner null-value term a next b)
  (cond ((> a b) null-value)
		(else (combiner (term a) (accumulate-recursive combiner null-value term (next a) next b)))))

(define (accumulate-iterative combiner null-value term a next b)
  (define (recurse combiner term a next b result)
	(cond ((> a b) result)
		  (else (recurse combiner term (next a) next b (combiner (term a) result)))))

  (recurse combiner term a next b null-value))
  

(define (sum a b term next)
  (define (sum-combiner x y) (+ x y))
  (define (null-value) 0)
  (accumulate-recursive sum-combiner (null-value) term a next b))

(define (product a b term next)
  (define (product-combiner x y) (* x y))
  (define (null-value) 1)
  (accumulate-iterative product-combiner (null-value) term a next b))

(define (sum-of-value a b)
  (define (term x) x)
  (define (next x) (+ x 1))
  (sum a b term next))

(define (factorial n)
  (define (term x) x)
  (define (next x) (+ x 1))
  (product 1 n term next))

(factorial 7)

(sum-of-value 4 10)
