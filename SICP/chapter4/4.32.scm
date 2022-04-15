(define (cons x y) (lambda (m) (m x y)))
(define (car lis) (lis (lambda (x y) x)))
(define (cdr lis) (lis (lambda (x y) (cons y '()))))

(define (list-ref lis n)
  (if (= n 0) (car lis)
      (list-ref (cdr lis) (- n 1))))


(define lis (cons (begin
                    (p "hello world")
                    1)
                  2))
(list-ref lis 0)

;; the advantage is even when you do car/cdr, it won't force evaluate the element. In the above expression for example, hello world is never evaluated.
