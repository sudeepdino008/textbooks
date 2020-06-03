(define (make-account password balance)
  (let ((incorrect-pass-count 0))
	(define (withdraw amount)
	  (if (>= balance amount)
		  (begin (set! balance (- balance amount))
				 balance
				 )
		  (error "Insufficient funds")
		  )
	  )
	(define (deposit amount)
	  (set! balance (+ balance amount))
	  balance
	  )
	(define (dispatch secret-password m)
	  (if (eq? secret-password password)
		  (begin
			(set! incorrect-pass-count 0)
			(cond ((eq? m 'withdraw) withdraw)
				  ((eq? m 'deposit) deposit)
				  (else (error "unknmown command" m))
				  )
			)
		  (begin
			(set! incorrect-pass-count (+ incorrect-pass-count 1))
			(if (>= incorrect-pass-count 7) (display "call the cops!"))
			(error "incorrect password")
			)
		  )
	  )
	dispatch
	)
  )

(define acc (make-account 'passwd 100))
((acc 'passwd2 'withdraw) 20)


(RESTART 1)
