
(define (sum function next-term a b)
  (define (inner-sum a b)
	(cond ((> a b) 0)
		  (else (+ (function a) (inner-sum (next-term a) b)))))

  (inner-sum a b))


(define (simpson-rule function a b n)
  (define (hvalue) (/ (- b a) n))
  (define (even? k) (= (remainder k 2) 0))
  (define (coefficient k) (cond ((= 0 k) 1)
								((= n k) 1)
								((even? k) 2)
								(else 4)))
  (define (xk a k h) (+ a (* k h)))
  (define (inner-function k) (* (coefficient k) (function (xk a k (hvalue)))))
  (define (next-term k) (+ k 1))
  (/ (* (hvalue) (sum inner-function next-term 0 n)) 3))

(define (cubes-approx a b n)
  (define (cube x) (* x x x))
  (simpson-rule cube a b n))

(cubes-approx 0 1 1000)
