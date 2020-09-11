
(define (stream-print s n)
  (if (= n 0) #t
      (begin
        (display (stream-car s))
        (display "\n")
        (stream-print (stream-cdr s) (- n 1)))))


(define (stream-filter proc s)
  (if (eq? (proc (stream-car s)) #t)
      (cons-stream (stream-car s) (stream-filter proc (stream-cdr s)))
      (stream-filter proc (stream-cdr s)))
  )

(define (distinct? lis)
  (define (count lis elem)
    (cond ((eq? lis '()) 0)
          ((eq? (car lis) elem) (+ 1 (count (cdr lis) elem)))
          (else (count (cdr lis) elem)))
    )

  (define (loop values)
    (cond ((eq? values '()) #t)
          ((> (count lis (car values)) 1) #f)
          (else (loop (cdr values)))))
  (define v (loop lis))
  v
  ;; (if v
  ;;     (begin (display lis) (newline) v)
  ;;    v)
  )

(define (next-combination combination)
  (cond ((eq? combination '()) '())
        ((eq? (car combination) 5) (cons 1 (next-combination (cdr combination))))
        (else (cons (+ 1 (car combination)) (cdr combination))))
  )

(define (combination-stream start)
  (cons-stream start (combination-stream (next-combination start))))


(define s (combination-stream (list 1 1 1 1 1)))

(define (puzzle-filter floors)
;;  (display floors)
;;  (newline)
  (let ((baker (car floors))
        (cooper (cadr floors))
        (fletcher (caddr floors))
        (miller (cadddr floors))
        (smith (car (cddddr floors))))
    (and (distinct? floors)
         (not (= baker 5))
         (not (= cooper 1))
         (not (= fletcher 5))
         (not (= fletcher 1))
         (> miller cooper)
         (not (= (abs (- smith fletcher)) 1))
         (not (= (abs (- fletcher cooper)) 1))))
  )

(define answer (stream-filter puzzle-filter s))
(stream-print answer 3)

