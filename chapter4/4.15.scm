(define (run-forever) (run-forever))
(define (try p) (if (halts? p p) (run-forever) 'halted))


if you evaluate (try try), and it halts (returns quoted 'halted), then that means that halts? must conclude that (try try) must halt, and therefore (halts? try try)  is true. But is it's true, then it should run-forever.

If (try try) never halts, then (halts? try try) must be false. But that's a contradiction because if it's false, it (try  try) would return 'halted.
