(define (mul-streams s1 s2)
  (cons-stream (* (car s1) (car s2))
               (mul-streams (cdr s1) (cdr s2)))
  )

(define ones (cons-stream 1 ones))
(define natural-numbers (cons-stream 1 (add-stream natural-numbers ones)))

(define factorials
  (cons-stream 1 (mul-streams factorials (add-stream natural-numbers ones))))
