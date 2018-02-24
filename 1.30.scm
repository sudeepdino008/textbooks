
;; (define (sum function next-term a b)
;;   (define (inner-sum a b)
;; 	(cond ((> a b) 0)
;; 		  (else (+ (function a) (inner-sum (next-term a) b)))))

;;   (inner-sum a b))


(define (sum term a next b)
  (define (iter a result)
	(if (cond ((> a b) result)
			  (else (iter (+ a 1) (+ result (term a)))))))
  (iter a 0))
