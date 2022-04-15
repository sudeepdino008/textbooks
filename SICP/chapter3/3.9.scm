(define (factorial n)
  (if (= n 1) 1 (* n (factorial (- n 1)))))


[global: factorial n] <- [n = 6]


g <- [n=6]
g <- [n=5]
...
g <- [n=1]


(define (factorial n) (fact-iter 1 1 n))
(define (fact-iter product counter max-count)
  (if (> counter max-count) product
      (fact-iter (* counter product) (+ counter 1)
                 max-count)))

g = [factorial // fact-iter]


g <- [n = 6] (factorial 6)
g <- [product = 1, counter = 1, max-count = 6]
g <- [* 1 1]
g <- [+ 1 1]
g <- [product = 1, counter=2, max-count = 6]
...

g <- [product = 720, counter = 6, mac-count = 6]
