;; (x+y)^n = nC0.x^n.y^0 + nC1.x^(n-1).y


;; nCy = nC(y-1) * (n-y)/y

 ;;;Left-aligned triangle, assuming the top most is at (row=1, column=1) 

;;;1 
 ;;;1  1 
 ;;;1  2  1 
 ;;;1  3  3  1 
 ;;;1  4  6  4  1 
 ;;;1  5  10 10 5  1 

(define (ncy n y prev)
  (cond ((= y 0) 1)
		(else (/
			   (* prev (- n (- y 1)))
			   y)
			  )
		)
  )

;; iterative process
(define (pascal3 row column)
  (define (pascal-iter3 i prev)
	(cond ((< i column) (pascal-iter3 (+ i 1) (ncy (- row 1) i prev)))
		  (else prev))
	)
  (pascal-iter3 0 1)
  )

;; recursive process
(define (pascal-rec row column)
  (define n (- row 1))
  (define k (- column 1))
  (cond ((= k 0) 1)
		((= n k) 1)
		(else (+ (pascal-rec (- row 1) column) (pascal-rec (- row 1) (- column 1))))
		)
  )
	

(pascal3 4 2)
(pascal-rec 5 3)
