(define (f1 x) x)
(define f2 (f1 f1))


(define t1 (real-time-clock))
(define (loop i n)
  (if (= i n) '()
      (begin
        (f1 2)
        (f2 2)
        (loop (+ 1 i) n))))
(loop 1 100)
(p (- (real-time-clock) t1))


;; with memoization the above runs in 55ms
;; without memoization, it runs in 300ms

;; part b

(define count 0)
(define (id x) (set! count (+ 1 count)) x)
(define (square x) (* x x))

(square (id 10))
count

;; with memoization   : 100 1
;; without memoization: 100 2
