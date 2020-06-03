;;(load "stream-imports.scm")
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




(define (integrate-series stream)
  (define (internal stream num)
    (cons-stream (/ (stream-car stream) num) (internal (stream-cdr stream) (+ num 1)))
    )

  (internal stream 1)
  )




;; b

(define minus-ones (cons-stream -1 minus-ones))

(define cosine-series
  (cons-stream 1 (integrate-series (stream-multiply sine-series minus-ones)))   ;; 1 0/1 -1/2 0/3 1/2*3*4
  )

(define sine-series
  (cons-stream 0 (integrate-series cosine-series))   ;; 0 1/1 0/2 -1/2*3
  )


;; can be executed by running the evaluator

(stream-print cosine-series 10)
(stream-print sine-series 10)
