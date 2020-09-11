;; with i and j set, the search for k will go on forever since amb is a DFS.

(define (an-integer-between low high)
  (require (<= low high))
  (amb low (an-integer-between (+ 1 low) high))
  )

(define (an-integer-greater-than n)
  (amb n (an-integer-greater-than (+ 1 n))))

(define (pythagorean-triple-with-k k)
  (let ((i (an-integer-between 1 k)))
    (let ((j (an-integer-between 1 i)))
      (require (= (+ (* i i) (* j j)) (* k k)))
      (list i j k))))

(define (a-pythagorean-triple)
  (let (k (an-integer-greater-than 1))
    (pythagorean-triple-with-k k)))
