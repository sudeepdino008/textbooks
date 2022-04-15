Alyssa's view. MIT Scheme (not the evaluator we're implementing) uses the transformation described in this chapter to have the definitions of a body declared as unassigned (or some other special marker) initially to allow simultaneous availability of variables when execution begins.

Topological sort can be used to figure out which definitions should be done first. This can allow for Eva's notion. However it's probably an overkill, and better to just throw an error and force the programmer to write a "better" procedure.


(let ((a 1)) (define (f x)
(define b (+ a x)) (define a 5)
(+ a b))
(f 10))

