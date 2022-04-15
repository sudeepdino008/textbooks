;; you can shave off a few instructions execution by having the most restrictive checks first (lesser number of 'require' for example)

;;earlier
(require
     (distinct? (list baker cooper fletcher miller smith)))
(require (not (= baker 5)))
(require (not (= cooper 1)))
(require (not (= fletcher 5)))
(require (not (= fletcher 1)))
(require (> miller cooper))
(require (not (= (abs (- smith fletcher)) 1)))
(require (not (= (abs (- fletcher cooper)) 1)))

;;optimised
(require
     (distinct? (list baker cooper fletcher miller smith))) ;; 3125 -> 120
(require (not (= (abs (- smith fletcher)) 1))) ;; 120 -> 72
(require (not (= (abs (- fletcher cooper)) 1))) ;;
(require (> miller cooper))
(require (not (= fletcher 5)))
(require (not (= fletcher 1)))
(require (not (= baker 5)))
(require (not (= cooper 1)))

;; the distinct? procedure might itself be expensive. So the only way to check is by actually measuring the execution times.
