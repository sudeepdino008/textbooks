;; stream functions
(define (stream-multiply s1  s2)
  (cons-stream (* (stream-car s1) (stream-car s2))
               (stream-multiply (stream-cdr s1) (stream-cdr s2))))

(define (stream-ref s n)
  (if (= n 0) (stream-car s) (stream-ref (stream-cdr s) (- n 1))))

(define (stream-print s n)
  (if (= n 0) 'true
      (begin
        (display (stream-car s))
        (display "\n")
        (stream-print (stream-cdr s) (- n 1)))))

(define (stream-map proc s)
  (cons-stream (proc (stream-car s)) (stream-map proc (stream-cdr s))))

(define (stream-filter proc s)
  ;;(display (list "here:" (stream-car s)))
  (if (eq? (proc (stream-car s)) 'true)
      (cons-stream (stream-car s) (stream-filter proc (stream-cdr s)))
      (stream-filter proc (stream-cdr s)))
  )

(define (stream-scale s m)
  (cons-stream (* (stream-car s) m) (stream-scale (stream-cdr s) m)))

(define (stream-add s1 s2)
  (cons-stream (+ (stream-car s1) (stream-car s2))
               (stream-add (stream-cdr s1) (stream-cdr s2))))

(define (stream-null? s)
  (eq? (stream-car s) 'the-empty-stream))

;;;;;;;;

(define (integral delayed-integrand initial-value dt)
  (define int
    (cons-stream initial-value
                 (let ((integrand (force delayed-integrand)))
                   (begin (display "integral")
                          (stream-add (stream-scale integrand dt) int)))))
  int)



(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)

;; running 
(stream-ref (solve (lambda (y) y) 1 0.001) 5)
