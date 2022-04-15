
(block-thread-events)
(declare)

(put)
(map)
(set-thread-event-block)
(signal-thread-event)
(condition-wait)

(define lis (list))
(define elem 222)
(append lis (list elem))
lis

(length lis)

(wait-for-io)
(block-thread-events)
(thread-mutex-owner)


(set! elem 13)
(RESTART 1)

(define qu (make-thread-queue))
(thread-queue/queue! qu 23)
(thread-queue/dequeue! qu)


(define (semaphore nthreads)
  (let ((queue-mutex (make-thread-mutex))
		(op-mutex (make-thread-mutex)))

	(define (wait)
	  (display "\nlocking thread mutex")
	  (display op-mutex)
	  (lock-thread-mutex op-mutex)
	  (newline)
	  (display nthreads)
	  (set! nthreads (- nthreads 1))
	  (cond ((< nthreads 0) (begin (display "was here\n")
								   (unlock-thread-mutex op-mutex)
								   (display "\nnow here\n")
								   (lock-thread-mutex queue-mutex)))
			(else (unlock-thread-mutex op-mutex)))
	  (display "finish")
	  )

	(define (signal)
	  (display "\n(signal)locking thread mutex")
	  (display op-mutex)
	  (lock-thread-mutex op-mutex)
	  (set! nthreads (+ nthreads 1))
	  
	  (display "\n(signal)unlocking thread mutex")
	  (display op-mutex)
	  (newline)
	  (display queue-mutex)
	  (newline)
	  (display nthreads)
	  (cond ((<= nthreads 0) (unlock-thread-mutex queue-mutex)))
	  (display "operartion done")
	  (unlock-thread-mutex op-mutex)
	  )

	(define (dispatch m)
	  (display "executing")
	  (display "\nthread is:")
	  (display (current-thread))
	  (newline)
	  (cond ((eq? m 'wait) wait)
			((eq? m 'signal) signal)
			(else (error "unknown request" m))
			)
	  )
	(begin
	  (lock-thread-mutex queue-mutex)
	  dispatch
	  )
	)
  )

(define sem1 (semaphore 0))
(define t2 (create-thread #f (lambda ()
							   (display "starting wait")
							   ((sem1 'signal))
							   (display "\nending wait")
							   )))

(display "wassup")
(display "ok")
((sem1 'wait))

(define t1 (create-thread #f (lambda () (display "hello"))))


(define s1 (semaphore 0))
((s1 'wait))


(define (blocking-queue)
  (let ((pushing (semaphore 1))
		(pulling (semaphore 0))
		(lis (list))
		(x 'nil))
	
	(define (enqueue elem)
	  ((pushing 'wait))
	  (display "\nenqueue")
	  (set! lis (append lis (list elem)))
	  ((pulling 'signal))
	  )

	(define (dequeue)
	  (begin 
		((pulling 'wait))
		(display "\ndequeue")
		(set! x (car lis))
		(set! lis (cdr lis))
		((pushing 'signal))
		x
		)
	  )

	(define (dispatch m)
	  (cond ((eq? m 'enqueue) enqueue)
			((eq? m 'dequeue) dequeue)
			(else (error "unknown request" m))
			)
	  )

	
	dispatch)
  )


(define queue1 (make-thread-queue))
(thread-queue/queue! queue1 23)
(thread-queue/queue! queue1 29)
(thread-queue/dequeue! queue1)



(RESTART 1)

(permutations 3)

(type? 4)

(list (car (list-tabulate 4 values)))

(define (ff)
  (let ((ww (list)))

	(define (fg)
	  (set! ww (list 2 3))
	  (display "ww\n")
	  (display ww)
	  (display "ee\n")
	  )
	(cond ((eq? 0 1) 123)
		  (else (let ()
				  (fg)
				  (display ww)
				  ww
				  )
				)
		  )
	)
  )

(ff)

(for-each (lambda (x) x
				  )
		  (list-tabulate 4 values))


(map (list-tabulate 4 values) (lambda (x) (+ x 4)))



(define (pair x y)
  (lambda (m)
    (cond ((eq? m 'car) x)
          ((eq? m 'cdr) y)
          (else (error "error!"))
    )
    )
  )


(define p (pair 2 3))

(p 'car)

(define p 1)
(symbol? 3)

(define (variable? exp) (symbol? exp))
(variable? p)



(define (tagged-list? exp tag)
  (if (pair? exp) (eq? (car exp) tag)
      false))

(define (assignment? exp) (tagged-list? exp 'set!))
(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))


p
(assignment? '(set! p 2))
(assignment-value '(set! p 2))


(caddr (list 1 2 3))




(define <var> <val>)
(define (<var> <parameters>) <body>)
(define <var>
  (lambda (<parameters>)
    <body>))


(define (definition? exp) (tagged-list? 'define))

(define (definition-variable exp)
  (if (symbol? (cadr exp)) (cadr exp)
      (caadr exp)))

(define (definition-value exp)
  (if (symbol? (cadr exp)) (caddr exp)
      (make-lambda (cdadr exp)  ;; parameters
                   (cddr exp) ;; body
                   )))
                   




(define (f var)
    (internal33 5)
  (define (internal33 i) (internal2 i))

  (define (internal2 i) (display i))
  )

(f 5)
