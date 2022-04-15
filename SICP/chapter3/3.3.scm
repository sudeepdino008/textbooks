(define (make-account password balance)
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
		(cond ((eq? m 'withdraw) withdraw)
			  ((eq? m 'deposit) deposit)
			  (else (error "unknmown command" m))
			  )
		(error "incorrect password")
		)
	)
  dispatch
  )

(define acc (make-account 'passwd 100))
((acc 'passwd2 'withdraw) 20)


(RESTART 1)
