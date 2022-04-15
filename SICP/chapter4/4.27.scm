(define count 0)
(define (id x) (set! count (+ count 1)) x)


(define w (id (id 10))) ;; w=('thunk '(id 10) env)
count
;;1
w   ;; (fi ('thunk '(id 10) env)) -> (av '(id 10) env):('thunk 10 env) -> (fi ('thunk 10 env)): ('eval-thunk 10) => (

;; (fi ('thunk '(id 10) env))
;; recurse: (av '(id 10) env) -> (eval '(id 10) env):('thunk 10)
;;          (fi ('thunk 10))


;;10


count
;; 2



;; Answer: 1,10,2
