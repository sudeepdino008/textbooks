
(define (accumulate combiner predicate null-value term a next b)
  (define (get-term x) (cond ((predicate (term x)) (term x))
							 (else null-value)))

  (define (accumulate-recursive a b)
	(cond ((> a b) null-value)
		  (else (combiner (get-term a) (accumulate-recursive (next a) b)))))

  (define (accumulate-iterative a b result)
	(cond ((> a b) result)
		  (else (accumulate-iterative (next a) b (combiner result (term a))))))

 ; (accumulate-recursive a b)
  (accumulate-iterative a b null-value)
  )


(define (sum n)
  (define (test? x) #t)
  (define (sum-combiner x y) (+ x y))
  (define (next x) (+ x 1))
  (define (term x) x)
  (accumulate sum-combiner test? 0 term 1 next n))

(sum 10)

(define (sum-of-even n)
  (define (even? x) (= (remainder x 2) 0))
  (define (sum-combiner x y) (+ x y))
  (define (next x) (+ x 1))
  (define (term x) x)
  (accumulate sum-combiner even? 0 term 1 next n))

(sum-of-even 10)
