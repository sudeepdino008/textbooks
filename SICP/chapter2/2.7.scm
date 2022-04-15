(define (make-interval a b) (cons a b))


(define (upper-bound a) (max (car a) (cdr a)))
(define (lower-bound a) (min (car a) (cdr a)))
