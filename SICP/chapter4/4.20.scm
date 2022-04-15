;; a

;;(letrec_custom ((⟨var1⟩ ⟨exp1⟩) . . . (⟨varn⟩ ⟨expn⟩))
;;         ⟨body⟩)

(define (letrec_custom exp) (tagged-list? exp 'letrec_custom))
(define (letrec_custom-assignments exp) (cadr exp))
(define (letrec_custom-body exp) (caddr exp))
(define (letrec_custom-variables exp) (map car (letrec_custom-assignments exp)))
(define (letrec_custom-expressions exp) (map cadr (letrec_custom-assignments exp)))

(letrec_custom-expressions '(letrec_custom ((var1 (exp1)) (var2 (exp2))) (body)))


;;(let ((var1 '*unassigned') (var2 '*unassigned'))
;;     (set! var1 (Exp1))
;;     (set! var2 (Exp2))
;;     (body)

(define (make-let intializations body)
  (cons 'let (cons intializations body))
  )

(define (letrec_custom->let exp)
  (define (get-unassigned-assignments variables)
    (map (lambda (var) (cons var '*unassigned)) variables)
    )
  
  (define (set-assignments assignments)
    (map (lambda (entry) (cons 'set! (cons (car entry) (cadr entry)))) assignments)
    )

  (define unassigned-assignments (get-unassigned-assignments (letrec_custom-variables exp)))
  (define set-assignments-var (set-assignments (letrec_custom-assignments exp)))
  (define body (letrec_custom-body exp))

  (make-let unassigned-assignments (append set-assignments-var (list body)))
  )



;;TEST

(letrec_custom->let '(letrec_custom ((var1 (exp1)) (var2 (exp2))) (body)))


(let ((even? (lambda (n) (if (= n 0) true (odd? (- n 1)))))
      (odd? (lambda (n) (if (= n 0) true (even? (- n 1))))))
  (display "hey"))
  
