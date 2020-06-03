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

;; pair streams 

(define (interleave s1 s2)
  (if (null? s1) s2
      (cons-stream (stream-car s1)
                   (interleave s2 (stream-cdr s1))))
  )

(define (pair s t)
  (cons-stream (cons (stream-car s) (stream-car t))
               (interleave
                (interleave (stream-map (lambda (telem) (cons (stream-car s) telem)) (stream-cdr t))
                            (stream-map (lambda (selem) (cons selem (stream-car t))) (stream-cdr s)))
                (pair (stream-cdr s) (stream-cdr t)))))

(define (series n)
    (cons-stream n (series (+ n 1))))
(define integers (series 1))

(define pair-series (pair integers integers))

(stream-print pair-series 10)

