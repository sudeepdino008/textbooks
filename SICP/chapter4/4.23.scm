The analyze-sequence in the text effectively forms nested lambdas, for example for a 4 statement sequence,

(lambda (env)
  ((lambda (env)
    ((lambda (env) (exp1 env) (exp2 env)) env)
    (exp3 env)
    ) env)
  (exp4 env))

For the version Alyssa gave, even after declaring the variables to reduce duplicate calls, there will be 5 procedure calls for each statement - car, cdr, null?, expression call, recursive.
So for 4 statements, it's 19 calls (last one doesn't need to recursive call).

For the above, there are 3 lambda applications, and each expression is evaluated once. So a total of 7 procedure calls.


