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


(define (merge-weighted s1 s2 weight)
  (let ((w1 (weight (stream-car s1)))
        (w2 (weight (stream-car s2))))
    ;;(display (list "mw: " (stream-car s1) " " (stream-car s2) " " w1 " " w2 "\n")) 
    (if (<= w1 w2)
        (cons-stream (stream-car s1) (merge-weighted (stream-cdr s1) s2 weight))
        (cons-stream (stream-car s2) (merge-weighted s1 (stream-cdr s2) weight))))
  )

(define (pair s t weight)
  ;;(display (list "\nhello: " (cons (stream-car s) (stream-car t)) "\n"))
  (cons-stream (cons (stream-car s) (stream-car t))
               (merge-weighted (stream-map (lambda (telem) (cons (stream-car s) telem)) (stream-cdr t))
                               (pair (stream-cdr s) (stream-cdr t) weight)
                               weight))
  )

(define (series n)
    (cons-stream n (series (+ n 1))))
(define integers (series 1))

(define (pair-series weight) (pair integers integers weight))

(define (weight-b inj)
  (let ((i (car inj))
        (j (cdr inj)))
     (+ (* i i i) (* j j j)))
  )



(define (compare-streams s1 s2 weight)
  (define (cons-car-equal sx sy)
    (if (= (car sx) (car sy))
        (if (= (cdr sx) (cdr sy)) true false)
        false))
  
  (let ((w1 (weight (stream-car s1)))
        (w2 (weight (stream-car s2))))
    (cond ((cons-car-equal (stream-car s1) (stream-car s2)) (compare-streams s1 (stream-cdr s2) weight))
          ((= w1 w2) (cons-stream w1 (compare-streams (stream-cdr s1) (stream-cdr s2) weight)))
          ((< w1 w2) (compare-streams (stream-cdr s1) s2 weight))
          (else (compare-streams s1 (stream-cdr s2) weight)))))




;;(trace weight-b)

(define ps (pair-series weight-b))
(define ramanujan-numbers (compare-streams ps ps weight-b))

(stream-print ramanujan-numbers 5)




;;;; Answer

;; ::> 1729
;; 4104
;; 13832
;; 20683
;; 32832
