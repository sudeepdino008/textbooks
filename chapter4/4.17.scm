let statement effectively introduces a new lambda, which creates a new frame.
This won't introduce any change in the execution because the enviroment queries (variable lookups etc.) would yield the same values in both cases.

Rather than use let, just use (define u 'unassigned) etc. right before the body, extending the samea environment. All the variables are defined by the time it starts executing the set! statements (which replaces defines)
