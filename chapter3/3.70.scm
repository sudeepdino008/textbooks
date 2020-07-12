;; stream functions
(define (stream-multiply s1  s2)
  (cons-stream (* (stream-car s1) (stream-car s2))
               (stream-multiply (stream-cdr s1)
                                (stream-cdr s2))))

(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))

(define (stream-print s n)
  (if (= n 0) 'true
      (begin
        (display (stream-car s))
        (display "\n")
        (stream-print (stream-cdr s) (- n 1)))))

(define (stream-map proc s)
  (cons-stream (proc (stream-car s))
               (stream-map proc (stream-cdr s))))

(define (stream-filter proc s)
  ;;(display (list "here:" (stream-car s)))
  (if (eq? (proc (stream-car s)) 'true)
      (cons-stream (stream-car s) (stream-filter proc (stream-cdr s)))
      (stream-filter proc (stream-cdr s)))
  )


(define (merge-weighted s1 s2 weight)
  (let ((w1 (weight (stream-car s1)))
        (w2 (weight (stream-car s2))))
    ;;(display (list "mw: " (stream-car s1) " " (stream-car s2) " " w1 " " w2 "\n")) 
    (if (<= w1 w2)
        (cons-stream (stream-car s1)
                     (merge-weighted (stream-cdr s1) s2 weight))
        (cons-stream (stream-car s2)
                     (merge-weighted s1 (stream-cdr s2) weight))))
  )

(define (pair s t weight)
  ;;(display (list "\nhello: " (cons (stream-car s) (stream-car t)) "\n"))
  (cons-stream (cons (stream-car s) (stream-car t))
               (merge-weighted (stream-map (lambda (telem)
                                             (cons (stream-car s) telem))
                                           (stream-cdr t))
                               (pair (stream-cdr s) (stream-cdr t))
                               weight))
  )

(define (series n)
    (cons-stream n (series (+ n 1))))
(define integers (series 1))

(define (pair-series weight) (pair integers integers weight))


;; part (a)
(define (weight inj)
;;  (display (list inj "\n"))
  (+ (car inj) (cdr inj)))

;; part (b)

(define (divisible? i j) (= (remainder i j) 0))
(define (valid? num)
  (cond ((divisible? num 2) 'false)
        ((divisible? num 3) 'false)
        ((divisible? num 5) 'false)
        (else 'true)))
(define (valid-pair? x)
  (cond ((eq? (valid? (car x)) 'false) 'false)
        ((eq? (valid? (cdr x)) 'false) 'false)
        (else 'true)))

(define (weight-b inj)
  (let ((i (car inj))
        (j (cdr inj)))
     (+ (* 2 i) (* 3 j) (* 5 i j)))
  )

;;(trace weight-b)
(define ps (pair-series weight))
(define ps1 (stream-filter valid-pair? ps))

(stream-print ps 1)

