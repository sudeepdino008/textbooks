;; 1st impl

(cons (* (car items) (car items)) (square-list (cdr items)))


;; 2nd impl

(map (lambda (x) (* x x)) items)

	  
