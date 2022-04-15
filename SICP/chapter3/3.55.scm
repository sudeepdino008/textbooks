(define (partial-sums stream)
  (cons-stream (car stream)
               (add-stream (partial-sums stream) (cdr stream)))
  )
