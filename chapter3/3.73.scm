;; helpers

(define (stream-add s1 s2)
  (cons-stream (+ (stream-car s1) (stream-car s2))
               (stream-add (stream-cdr s1) (stream-cdr s2)))
  )

                    
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

(define (stream-scale s1 scale)
  (stream-map (lambda (x) (* x scale)) s1))

(define (stream-filter proc s)
  ;;(display (list "here:" (stream-car s)))
  (if (eq? (proc (stream-car s)) 'true)
      (cons-stream (stream-car s) (stream-filter proc (stream-cdr s)))
      (stream-filter proc (stream-cdr s)))
  )


;; solution

(define (integral integrand-stream initial-value dt)
  (define result
    (cons-stream initial-value
                 (stream-add result
                             (stream-scale integrand-stream dt))))
  result)


(define (constant-stream num)
  (cons-stream num (constant-stream num)))

(define (RC R C dt)
  (lambda (current-stream v0)
    (let ((current-stream-integral (stream-scale (integral current-stream 0 dt) (/ 1 C)))
          (v0-stream (constant-stream v0))
          (ri-stream (stream-scale current-stream R)))
      (stream-add current-stream-integral
                  (stream-add v0-stream ri-stream)))))

(define RC1 (RC 5 1 0.5))

(define f (RC1 (constant-stream 1) 5))

(stream-print f 10)
      
