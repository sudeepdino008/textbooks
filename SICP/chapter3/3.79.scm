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


(define (integral delayed-integrand initial-value dt)
  (cons-stream
   initial-value
   (let ((integrand (force delayed-integrand)))
          (integral (delay (stream-cdr integrand))
                   (+ (* dt (stream-car integrand))
                      initial-value)
                   dt))))


(define (stream-map2 proc s1 s2)
  (cons-stream (proc (stream-car s1) (stream-car s2))
               (stream-map2 proc (stream-cdr s1) (stream-cdr s2))))

(define (solve-2nd f y0 dy0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (integral (delay ddy) dy0 dt))
  (define ddy (stream-map2 f dy y))
  y
  )

;; y = 2t.e^t
;; y' = 2.e^t + 2.t.e^t
;; y'' = 4.e^t + 2.t.e^t = 2y'-y


(stream-ref (solve-2nd (lambda (yy y) (- (* 2 yy) y)) 0 2 0.001) 1000)


