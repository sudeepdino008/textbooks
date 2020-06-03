;; return 3

(define (count-pairs x)
  (if (not (pair? x)) 0
      (+ (count-pairs (car x))
         (count-pairs (cdr x))
         1))
  )

(define v (cons 1 (cons 2 (cons 3 4))))
(count-pairs v)


;; return 4
(define w1 (cons 1 2))
(define w2 (cons w1 w1))
(define w3 (cons 1 w2))

(count-pairs w3)


;; return 7
(define w1 (cons 1 2))
(define w2 (cons w1 w1))
(define w3 (cons w2 w2))

(count-pairs w3)

;; never returns
;; key is lazy eval through lambda, which allows constructing a loop
(define w1 (lambda () (cons (w2) (w2))))
(define w2 (lambda () (cons (w3) (w3))))
(define w3 (lambda () (cons (w1) (w1))))

(count-pairs (w1))


;; OR
 (define str4 '(foo bar baz)) 
 (set-cdr! (cddr str4) str4) 
 (count-pairs str4) 

