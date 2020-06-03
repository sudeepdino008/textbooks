;; 1st impl

(cons (* (car items) (car items)) (square-list (cdr items)))


;; 2nd impl

(map (lambda (x) (* x x)) items)

	  
(define (map2 transform lis)
  (cond ((null? lis) (list))
		(else (append (list (transform (car lis))) (map2 transform (cdr lis))))
   )
  )


(map2 (lambda (x) (* x x)) (list 1 2 3 4))
