
(define (delay x) (lambda () (x)))
(define (force x) (x))

(define (cons-stream a b) (cons a (delay b)))

(define (car-stream a) (car a))
(define (cdr-stream a) (force (cdr a)))


(define (stream-enumerate low high)
  (display low)
  (newline)
  (display high)
  (newline)
  (newline)
  (cond ((> low high) '())
        (else (cons low (lambda () (stream-enumerate (+ 1 low) high)))))
  )


(define se (stream-enumerate 1 10))

(car-stream se)
(car (cdr-stream (cdr-stream se)))



(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map ⟨??⟩ argstreams))
       (apply stream-map (cons proc (map stream-cdr argstreams))))))
