(define (reverse lis)
  (cond ((null? (cdr lis)) (list (car lis)))
        (else (append (reverse (cdr lis)) (list (car lis))))
		)
  )

(reverse (list 1 2 3 4))



(define (for-each proc lis)
  (cond ((null? lis) #t)
		(else ((proc (car lis)) (for-each proc (cdr lis))))
		)
  )

(for-each (lambda (x) (newline) (display x)) (list 1 2 3 4))
		 


(car ''alpha)

(car '(quote alpha))

(define x 10)
(parallel-execute (lambda () (set! x (* x x)))
				  (lambda () (set! x (+ x 1))))




(define (kkk a . others)
  (newline)
  (display a)
  (newline)
  (display others)
;;  (cond ((eq? others '()) (newline))
;;		(else (kkk (car others) (cdr others))))
  )


(car '(1))

(eq? (cdr '(1)) '())
		
(kkk 23 1 3)

(define other2 '(1 3))
(car other2)
(quotient 1101 100)

(define dd (eq? 1 1))

(define x (read))
x

(display x)

(define y (read-char))
y

(current-input-port)
(define xxx (read-char (current-input-port)))
(display xxx)


(define tt (make-mutex))

(define name (read-line))
name


(RESTART 1)

(define (accumulate op initial sequence)
  (cond ((null? sequence) initial)
		(else (op (car sequence)
				  (accumulate op initial (cdr sequence))))
		)
  )

(define (filter predicate? sequence)
  (cond ((null? sequence) 'nil)
		((predicate? (car sequence)) (cons (car sequence) (filter predicate (cdr sequence))))
		(else (filter predicate (cdr sequence)))
		 )
  )

(define (map mapper sequence)
  (accumulate (lambda (x y) (cons (mapper (car sequence))
								  (map mapper (cdr sequence))))
			  'nil
			  sequence)
  )

(map (lambda (x) (+ x 2)) (list 12 22 89))

(filter (lambda (x) (= (% x 2) 0)


(define (replace-at lis value pos)
  (define (internal-replace-at lis value pos curr-pos)
	
	)
  )


(define serializer1 (make-serializer))
((serializer withdraw) amount)

(define (make-serializer)
  (let ((mutex (make-mutex)))
	(lambda (func)
	  (define (internal-serialzer . args)
		(mutex 'acquire)
		(let ((result (apply func args)))
		  (mutex 'release)
		  result)
		)
	  internal-serializer)
	)
  )

(define (hello)
  (display "hello world"))

(define t1 (create-thread #f hello))
(current-thread)
(thread-dead? t1)

(define (failed)
  (display "failed"))

(define (make-thread continuation)
  (let ((thread (%make-thread)))
    (set-thread/continuation! thread continuation)
    (set-thread/floating-point-environment! thread (flo:default-environment))
    (set-thread/root-state-point! thread
				  (current-state-point state-space:local))
    (add-to-population!/unsafe thread-population thread)
    (thread-running thread)
    thread))

(define-integrable (without-interrupts thunk)
  (let ((interrupt-mask (set-interrupt-enables! interrupt-mask/gc-ok)))
    (let ((value (thunk)))
      (set-interrupt-enables! interrupt-mask)
      value)))

(define t2 (make-thread hello))
(load "runtime/thread.scm")
(threads-list)
(make-thread-mutex)

(make-thread-queue)
(thread-population)
(create-thread)

(define (inp)
  (define val (read))
  (display "input value:")
  (display val)
  (newline)
  )

(define (out)
  (write 123))
(define t2 (create-thread #f inp))
(define t3 (create-thread #f out))


(inp)
23

;;(RESTART 1)

(define (write-something output-port)
  (write '123 output-port))


(parameterize (())

(define output-port (notification-output-port))
output-port
(write-something output-port)
(read-line output-port)
(string->number (read output-port))


