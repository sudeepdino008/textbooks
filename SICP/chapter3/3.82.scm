;; stream functions
(define (stream-multiply s1 s2)
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


;;;;;;;;;;;;;;;;;;;;;;;;;


(define (monte-carlo experiment-stream passed failed)
  (define (next passed failed)
    (cons-stream (/ passed (+ passed failed))
                 (monte-carlo (stream-cdr experiment-stream) passed failed)))
  (if (stream-car experiment-stream)
      (next (+ 1 passed) failed)
      (next passed (+ 1 failed)))
  )

(define (random-in-range low high) (let ((range (- high low)))
                                     (+ low (random (* 1.0 range)))))

(define (square x) (* x x))
  
(define (inside? x y x1 y1 r)
    ;; (display x)
    ;; (display " ")
    ;; (display y)
    
    ;; (newline)
  (define lhs (+ (square (- x x1)) (square (- y y1))))
  (define rhs (square r))
  (<= (- lhs rhs) 0)
  )


(define (inside?-stream x1 y1 r)
  (define upper-left-corner-x (- x1 r))
  (define upper-left-corner-y (- y1 r))
  (define lower-right-corner-x (+ x1 r))
  (define lower-right-corner-y (+ y1 r))

  (define rand-x (random-in-range upper-left-corner-x lower-right-corner-x))
  (define rand-y (random-in-range upper-left-corner-y lower-right-corner-y))
  
  (define int (cons-stream (inside? rand-x rand-y x1 y1 r)
                           (inside?-stream x1 y1 r)))
  int
  )

(stream-print (inside?-stream 5 7 3) 10)

(define pi4 (monte-carlo (inside?-stream 5.0 7.0 3.0) 0.0 0.0))
(define pi (stream-scale pi4 4.0))


;;(stream-ref (stream-scale (monte-carlo (inside?-stream 5.0 7.0 3.0) 0.0 0.0) 4.0) 80000)

(stream-ref pi 20000)


