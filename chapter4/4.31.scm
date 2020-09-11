;; evaluator implementation done in partially-lazy-evaluator.scm


(define (f a (b lazy) c (d lazy-memo))
  (cond ((= a 0) b)
        (else (+ c d d)))
  )

(define acount 0)
(define a 1)
;; (define b (begin
;;             (set! acount (+ 1 acount))
;;             2))
(define c 10)

(f a (/ 1 0) c (begin
                 (set! acount (+ 1 acount))
                 2)
   )
acount
                 
;; expected output: 14 1
