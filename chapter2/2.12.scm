(define (make-center-percent c p)
  (make-center-width c (* c p))
  )

(define (percent interval)
  (/ (width interval) (center interval))
  )
