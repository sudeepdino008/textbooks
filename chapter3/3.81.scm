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


(define (random-stream inputs)
  (define (random-update commands prev-state init-state)
    ;;(display prev-state)
    ;;(display "\n")
    ;;(display init-state)
    ;;(display "\n")
    (if (eq? (car commands) 'g)
        (let ((x (random 100 prev-state)))
          (cons-stream x (random-update (cdr commands) prev-state init-state)))
        (let ((copy-init-state (make-random-state init-state)))
          (let ((x (random (car commands) init-state)))
            (cons-stream x (random-update (cdr commands) init-state copy-init-state))))))
  (define rs (make-random-state))
  (random-update inputs rs (make-random-state rs))
  )

(stream-print (random-stream (list 'g 'g 'g 100 'g 'g 'g 'g 100 'g 'g 'g)) 11)
