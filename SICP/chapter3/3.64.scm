;; stream functions
(define (stream-multiply s1  s2)
  (cons-stream (* (stream-car s1) (stream-car s2))
               (stream-multiply (stream-cdr s1) (stream-cdr s2))))

(define (stream-ref s n)
  (if (= n 0) (stream-car s) (stream-ref (stream-cdr s) (- n 1))))

(define (stream-print s n)
  (if (= n -1) 'true
      (begin
        (display (stream-car s))
        (display "\n")
        (stream-print (stream-cdr s) (- n 1)))))

(define (stream-map proc s)
  (cons-stream (proc (stream-car s)) (stream-map proc (stream-cdr s))))

;; solution

(define (sqrt-improve guess x)
  (define (average a b)
    (/ (+ a b) 2))
  (average guess (/ x guess)))

(define (sqrt-stream x)
  (define guesses 
    (cons-stream 1.0 (stream-map (lambda (a) (sqrt-improve a x)) guesses)))
  guesses)

(define (stream-limit s tolerance)
  (define (abs x) (if (< x 0) (- x) x))
  (define (internal curr-stream prev)
    (let ((curr (stream-car curr-stream)))
      (if (< (abs (- prev curr)) tolerance)
          curr
          (internal (stream-cdr curr-stream) curr))))
  (internal (stream-cdr s) (stream-car s))
  )


(define (sqrt x tolerance)
  (stream-limit (sqrt-stream x) tolerance))

(sqrt 2 0.00000000001)
