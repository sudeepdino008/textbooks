(define (make-mobile left right)
  (list left right)
  )

(define (make-branch length structure)
  (list length structure))


(define (left-branch mobile)
  (car mobile)
  )

(define (right-branch mobile)
  (cadr mobile))


(define (branch-length branch)
  (car branch))

(define (branch-structure branch)
  (cadr branch))


(define (is-weight? entity)
  (not (list? entity)))

(define (is-branch? entity)
  (and (not (null? entity)) (not (list? (car entity))))
  )


(define (total-weight mobile)

  (cond ((null? mobile) 0)
        ((is-weight? mobile) mobile)
		((is-branch? mobile) (total-weight (branch-structure mobile)))
		(else (+ (total-weight (left-branch mobile)) (total-weight (right-branch mobile)))))
  )


(define b1 (make-branch 2 4))
(define b2 (make-branch 3 5))
(define b3 (make-branch 1 1))

(define mobile12 (make-mobile b1 b2))
(define bcomplex (make-branch 7 mobile12))

;;(define b4 (make-branch 4 b3))

(define mobile (make-mobile bcomplex b3))

(total-weight mobile)



(define (is-balanced? mobile)
  (define (torque branch)
	(* (total-weight (branch-structure branch)) (branch-length branch))
	)
  (cond ((null? mobile) true)
		((is-weight? mobile) true)
		(else (let ((lb (left-branch mobile))
					(rb (right-branch mobile)))
				(and (= (torque lb) (torque rb))
					 (is-balanced? (branch-structure lb))
					 (is-balanced? (branch-structure rb)))
				)
			  )
		)
  )


(is-balanced? mobile)


(define br1 (make-branch 2 3))
(define br2 (make-branch 3 2))
(define mobile12 (make-mobile br1 br2))
(define br3 (make-branch 2 mobile12))

(define br5 (make-branch 1 4))
(define br6 (make-branch 4 1))
(define mobile56 (make-mobile br5 br6))
(define br4 (make-branch 2 mobile56))

(define mobile (make-mobile br3 br4))
mobile
(is-balanced? mobile)

