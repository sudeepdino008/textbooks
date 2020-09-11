;; Ben: unless as a special form in applicative order

(define (unless-predicate exp) (cadr exp))
(define (unless-alternative exp) (caddr exp))
(define (unless-consequent exp)
  (if (not (null? (cdddr exp)))
    (cadddr exp)
    'false))
(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))


(define (unless->if exp)
  (make-if (if-predicate exp) (if-consequent exp) (if-alternative exp))
  )
  

;; Alyssa:  If unless if a function, we can do things like below.

(define list1 (list 1 2 3 4 5))
(define list2 (list 6 7 8 9 10))
(define picker-list '(#t #t #f #f #f))
(map unless picker-list list1 list2)

;; Regardless, it can be easily converted to a function by wrapping it around a lambda, and there's not much point in Alyssa's claim.
