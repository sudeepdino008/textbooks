memoization or no memoization, the stream being passed to stream-map is a fresh instance of sqrt-stream. So to calculate the next guess, the all the previous guess will have to be recalculated.
