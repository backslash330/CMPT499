;;; (translation-of-program (scan&parse "let x = 5 in -(x,2)"))
;;; (a-program (let-exp '(x) (list (const-exp 5)) (diff-exp (var-exp 'x) (const-exp 2))))
;;; (a-program (nameless-let-exp (const-exp 5) (diff-exp (nameless-var-exp 0) (const-exp 2))))

;;; > (translation-of-program (scan&parse "let x = 5 y=3 in -(x,y)"))
;;; . . parsing: at line 1: looking for "in", found identifier y in production
;;; ((string "let") (term identifier) (string "=") (non-term expression) (string "in") (non-term expression) (reduce #<procedure:let-exp>))