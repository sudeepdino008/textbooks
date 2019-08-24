
;; 1.11

;recursive
(define (f n)
  (if (< n 3)
	  n
	  (+ (f (- n 1)) (* 2 (f (- n 2))) (* 3 (f (- n 3))))))

(f 3)


										;iterative

(define (iter-f n)
  (define (iter-proc-f x y z it)
	(cond ((= it 0) x)
		  (else (iter-proc-f y z (+ (* 3 x) (* 2 y) z) (- it 1)) )))
  
  (iter-proc-f 0 1 2 n))


(iter-f 70)
