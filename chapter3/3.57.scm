(define fibs (cons-stream
              0
              (cons-stream 1 (add-streams (stream-cdr fibs) fibs))))


;; when (stream-cdr fibs) is expanded later, it won't return 1 even though it's been calculated. It'll be "substituted" by (cs 1 (as (cdr fibs) fibs)) and follow the execution from here. This leads to exponential time complexity.
