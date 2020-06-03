
(define (smooth input-stream)
  (define (internal s forward-s)
    (cons-stream (/ (+ (stream-car s) (stream-car forward-s)) 2)
                 (internal (stream-cdr s) (stream-cdr forward-s))))

  (cons-stream (/ (stream-car input-stream) 2)
               (internal input-stream (stream-cdr input-stream))))


(define (make-zero-crossings input-stream last-value)
  (let ((avpt (/ (+ (stream-car input-stream) last-value) 2)))
    (cons-stream (sign-change-detector avpt last-value)
                 (make-zero-crossings (stream-cdr input-stream)
                                      avpt))))

