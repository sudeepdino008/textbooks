(define (mul-streams s1 s2)
  (cons-stream (* (car s1) (car s2))
               (mul-streams (cdr s1) (cdr s2)))
  )



(define factorials
  (cons-stream 1 (mul-streams factorials (add-stream factorials ones)))
  )
