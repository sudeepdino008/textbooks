((lambda (n)
   ((lambda (fact) (fact fact n))
    (lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1)))))
    )
   )
 10)



fact: (lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1)))))


;; a
ft = fact, k = 10
(* 10 (fact fact 9))


;; b
(define (f x)
  ((lambda (even? odd?) (even? even? odd? x))
   (lambda (ev? od? n)
     (if (= n 0) true (od? ev? od? (- n 1))))
   (lambda (ev? od? n)
     (if (= n 0) false (ev? ev? od? (- n 1))))
   ))


(f 2)



even? : (ev? od? n) (if (= n 0) true (od? ⟨??⟩ ⟨??⟩ ⟨??⟩))
odd? : (ev? od? n) (if (= n 0) false (ev? ⟨??⟩ ⟨??⟩ ⟨??⟩))

(e e o 5)
(o e o 4)
(e e o 3)
(o e 0 2)
(e e o 1)
(o e o 0)
(od? ?? ?? ??)
