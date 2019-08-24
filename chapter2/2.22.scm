(define (square-list items)
  (define (iter things answer)
	(if (null? things)
		answer
		(iter (cdr things)
			  (cons (square (car things)) answer))))
  (iter items (list))
  )

(square-list (list 1 2 3))

(iter (1 2 3) nil)
(iter (2 3) (1))
(iter (3) (4 1))


;; reverse order because answer is appended at last



(define (square-list2 items)
  (define (iter things answer)
	(if (null? things)
		answer
		(iter (cdr things)
			  (cons answer (square (car things))))))
  (iter items (list))
  )

(iter (1 2 3) nil)
(iter (2 3) (1))
(iter (3) ((1) 

(square-list2 (list 1 2 3))

;; it's not creating a list, the first element is of list type causing the  return to be: (((() . 1) . 4) . 9)
