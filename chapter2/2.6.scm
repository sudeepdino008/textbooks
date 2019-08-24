(define zero (lambda (f) (lambda (x) x)))

(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))






;;one = (add-1 zero)
;;(lambda (f) (lambda (x) (f ((zero f) x))))
;;(lambda (f) (lambda (x) (f x)))

;; using substitution, one comes out:
(define one (lambda (f) (lambda (x) (f x))))

;; two = (add-1 one)
;; (lambda (f) (lambda (x) (f ((one f) x))))
;; (lambda (f) (lambda (x) (f (f x))))
(define two (lambda (f) (lambda (x) (f (f x)))))


;; gheneral addition
;; gheneral form seems to be: (define n (lambda (f) (lambda (x) (f (f (f....n times x))))))

(define (+ m n)
  ((m f) ((n f) x))
  )

