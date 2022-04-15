;; a: The side effects (printling newline and element) will be carried out. The thunked "(car items)" will be evaluated on display command.

(define (p1 x)
  (set! x (cons x '(2)))
  x)
(define (p2 x)
  (define (p e)
    e
    x)
  (p (set! x (cons x '(2))))
  )

;; b:
;; original eval-sequence:
;; (p1 1) -> (1 (2))
;; (p2 1) -> 1

;; Cy's eval-sequence:
;; (p1 1) -> (1 (2))
;; (p2 1) -> (1 (2))

;; c: No change because the thunk is evaluated before being applied to the lambda function, while in the original eval-sequence, the thunk is evaluated after lambda is applied. This distinction results in no difference in output however.

;; d: Cy's implementation is more "natural" in that the variable e (which is a thunk) is been applied. There will be usecases where a user might want to do that. The only plausible reason for mentioning the variable e in the sequence is to evaluate the thunk.
;; On the other hand, force evaluating the non-last members of the sequence goes against the principle of lazy evaluation. It's like an exceptional case and that adds a cognitive overload on someone using this language.
;; My choice boils down to what is more inuitive, and Cy's implementation leads to a more inuitive use.



;; From internet: The only sane reason to include non-final sequence members is for the side effects they produce before evaluating the final statement. Therefore Cy's method is preferred.
