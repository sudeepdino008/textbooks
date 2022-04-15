v: (1)
w: (4 3 2 1)


(define (mystery x) (define (loop x y)
(if (null? x) y
(let ((temp (cdr x))) (set-cdr! x y) (loop temp x))))
(loop x '()))


(define v (list 1 2 3 4))
v
(define w (mystery v))
v
w
