
(define lis (list 1 3 (list 5 7) 9))
lis
(car (cdr (car (cdr (cdr lis)))))

(define lis (list (list 7)))
lis
(car (car lis))


(define lis (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7)))))))

(car (cdr
 (car (cdr
  (car (cdr
   (car (cdr
	(car (cdr
	 (car (cdr lis))
	 ))
	))
   ))
  ))
 ))


