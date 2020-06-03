(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream low
                   (stream-enumerate-interval (+ low 1) high))))

(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))


(define (stream-map proc s)
  (if (stream-null? s) the-empty-stream
      (cons-stream (proc (stream-car s))
                   (stream-map proc (stream-cdr s)))))




(define (show x) (display-line x) x)

(define x (stream-map show (stream-enumerate-interval 0 10)))
;; 0

(cons-stream 0 (delay (sei 1 10)))
x = (cons-stream 0 (delay (sm show (cons-stream 1 (delay (sei 2 10))))))

(stream-ref x 5)
;; 12345

(sm show (cons-stream 1 (delay (sei 2 10))))
 -> 4

1
(sr (cons-stream 1 (sm show (cons-stream 2 (delay (sei 3 10))))) 4)
2
(sr (cons-stream 2 (sm show (cons-stream 3 (delay (sei 4 10))))) 3)
3
(sr (cons-stream 3 (sm show (cons-stream 4 (delay (sei 5 10))))) 2)
4
(sr (cons-stream 4 (sm show (cons-stream 5 (delay (sei 6 10))))) 1)
5
(sr (cons-stream 5 (sm show (cons-stream 6 (delay (sei 7 10))))) 0)


(stream-ref x 7)
;;1234567    -> without caching
;;67           ->with caching
