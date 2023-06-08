#lang racket
(require eopl)
; Assignment 5

; NOTE Q1A and Q1b need to be uncommented together to run
; Q1C and Q1D are independent of all other questions including each other
; Quesiton 1a
(define lexical-spec
  '((white-sp (whitespace) skip)
    (number (digit (arbno digit)) number)
    (identifier (letter (arbno (or letter digit))) symbol)
    (add-op ((or "+" "-")) symbol)
    (mul-op ((or "*" "/")) symbol)
 ) )

(define grammer-spec
  '((line (arith-expr ";") current-line)
    (arith-expr (arith-term (arbno add-op arith-term)) current-arith-expr)
    (arith-term (arith-factor (arbno mul-op arith-factor)) current-arith-term)
    (arith-factor (number) number-arith-factor)
    (arith-factor ("(" arith-expr ")") paren-arith-factor)
 ))

 (sllgen:make-define-datatypes lexical-spec grammer-spec)

 (define scan&parse
  (sllgen:make-string-parser lexical-spec grammer-spec))

; test cases
; (scan&parse "(1+2);")
; (scan&parse "(1+2*3);")
; (scan&parse "(1+2*3-4);")
; (scan&parse "(1+2*3-4/5);")

; Question 1b

(define value-of-line
  (lambda (ln)
    (cases line ln
      (current-line (expression)
        (value-of-arith-expr expression)
))))

(define value-of-arith-expr
  (lambda (expression)
    (cases arith-expr expression
      (current-arith-expr (term operants terms)
        (combining-value-of value-of-term term operants terms)
))))

(define value-of-term
  (lambda (term)
    (cases arith-term term
      (current-arith-term (factor operants factors)
        (combining-value-of value-of-factor factor operants factors)))))

(define value-of-factor
  (lambda (factor)
    (cases arith-factor factor
      (number-arith-factor (num)
        num)
      (paren-arith-factor (expr)
        (value-of-arith-expr expr)))))

(define combining-value-of
  (lambda (value-of term operants terms)
    (let ((combine (lambda (current-operant term accumulator)
                     ((operator->func current-operant) accumulator (value-of term)))))
      (foldl combine (value-of term) operants terms))))

(define operator->func
  (let ((operator-dict (list (cons '+ +) (cons '- -) (cons '* *) (cons '/ /))))
    (lambda (op)
      (cdr (assoc op operator-dict)))))

(define read-eval-print
  (sllgen:make-rep-loop "-->" value-of-line
    (sllgen:make-stream-parser lexical-spec grammer-spec)))


; Question 1c

;;; ; we use an environment similar to the languages LET, LETREC, PROC
;;; (define-datatype environment environment?
;;;   (empty-env)
;;;   (extend-env (saved-var symbol?)
;;;               (saved-val number?)
;;;               (saved-env environment?)))

;;; (define (apply-env env search-var)
;;;   (if (environment? env)
;;;     (cases environment env
;;;       (empty-env () (error 'apply-env "No binding for ~v in the Environment" search-var) )
;;;       (extend-env (saved-var saved-val saved-env)
;;;         (if (eqv? saved-var search-var)
;;;           saved-val
;;;           (apply-env saved-env search-var))))
;;;     (error 'apply-env "Expected an environment.")))  


;;; ; same as before
;;; (define scanner-spec
;;;   '((white-sp (whitespace) skip)
;;;     (number (digit (arbno digit)) number)
;;;     (identifier (letter (arbno (or letter digit))) symbol)
;;;     (add-op ((or "+" "-")) symbol)
;;;     (mul-op ((or "*" "/")) symbol)))

;;; (define grammer-spec
;;;   '((line (arith-expr ";") current-line)
;;;     (arith-expr (arith-term (arbno add-op arith-term)) current-arith-expr)
;;;     (arith-term (arith-factor (arbno mul-op arith-factor)) current-arith-term)
;;;     (arith-factor (number) number-arith-factor)
;;;     (arith-factor (identifier) var-arith-factor)
;;;     (arith-factor ("(" arith-expr ")") paren-arith-factor)))

;;; (sllgen:make-define-datatypes scanner-spec grammer-spec)

;;; ; we start at the line level, which leads to the arith-expr level
;;; (define value-of-line
;;;   (lambda (env)
;;;     (lambda (ln)
;;;       (cases line ln
;;;         (current-line (expression)
;;;           (value-of-arith-expr env expression))))))

;;; ; from the arith-expr level, we go to the arith-term level
;;; (define value-of-arith-expr
;;;   (lambda (env expression)
;;;     (cases arith-expr expression
;;;       (current-arith-expr (term operants terms)
;;;       ; we combine the value of the term with the value of the rest of the terms
;;;         (combining-value-of (value-of-term env) term operants terms)
;;; ))))

;;; (define value-of-term
;;;   (lambda (env)
;;;     (lambda (term)
;;;       (cases arith-term term
;;;         (current-arith-term (factor operants factors)
;;;         ; we combine the value of the factor with the value of the rest of the factors
;;;           (combining-value-of (value-of-factor env) factor operants factors)
;;; )))))

;;; (define value-of-factor
;;;   (lambda (env)
;;;     (lambda (factor)
;;;       (cases arith-factor factor
;;;       ; if we have a number, we just return it
;;;         (number-arith-factor (num)
;;;           num)
;;;           ; if we have a variable, we look it up in the environment
;;;         (var-arith-factor (var)
;;;           (apply-env env var))
;;;           ; if we have a parenthesized expression, we evaluate it, which will take us back to the arith-expr level
;;;         (paren-arith-factor (expression)
;;;           (value-of-arith-expr env expression)
;;;  )))))

;;; (define combining-value-of
;;;   (lambda (value-of term ops terms)
;;;   ; we start with the value of the term
;;;   ; we then combine it with the value of the rest of the terms
;;;   ; we do this by applying the operator to the accumulator and the value of the term
;;;     (let ((combine (lambda (current-operant term accumulator)
;;;                       ; we get the function from the operator and apply it to the accumulator and the value of the term
;;;                      ((operator->func current-operant) accumulator (value-of term)))))
;;;       ; we fold the combine function over the list of operators and terms
;;;       (foldl combine (value-of term) ops terms)
;;;  )))

;;; (define operator->func
;;;   (let ((operator-dict (list (cons '+ +) (cons '- -) (cons '* *) (cons '/ /))))
;;;     (lambda (op)
;;;       (cdr (assoc op operator-dict)
;;;  ))))

;;; (define example-env
;;;   (extend-env 'a 1
;;;     (extend-env 'b 2
;;;       (empty-env))))

;;; (define read-eval-print
;;;   (let ((parser (sllgen:make-stream-parser scanner-spec grammer-spec)))
;;;     ; the environment is taken when read-eval-print is caled
;;;     ; example (read-eval-print example-env)
;;;     ; here a=1 and b-2 (a+b)=3
;;;     (lambda (env)
;;;       ((sllgen:make-rep-loop "-->" (value-of-line env) parser)))))

; Question 1d

;;; ; declare the environment as a datatype
;;; (define-datatype environment environment?
;;;   (empty-env)
;;;   (extend-env (saved-var symbol?)
;;;               (saved-val number?)
;;;               (saved-env environment?)))

;;; (define (apply-env env search-var)
;;;   (if (environment? env)
;;;     (cases environment env
;;;       (empty-env () (error 'apply-env "No binding for ~v in the Environment" search-var) )
;;;       (extend-env (saved-var saved-val saved-env)
;;;         (if (eqv? saved-var search-var)
;;;           saved-val
;;;           (apply-env saved-env search-var))))
;;;     (error 'apply-env "Expected an environment.")))  

;;; (define report-no-binding-found
;;;   (lambda (search-var env)
;;;     (eopl:error 'apply-env "No binding for ~s in ~s" search-var env)))

;;; (define report-invalid-env
;;;   (lambda (env)
;;;     (eopl:error 'apply-env "Bad environment ~s" env)))


;;; ; declare the scanner specs
;;; ; Note, minus (and therefore plus) have to move to the grammer. This is because
;;; ; they will get conused with the uniary minus. So we need to be explicit
;;; (define lexical-spec
;;;   '((white-sp (whitespace) skip)
;;;     (number (digit (arbno digit)) number)
;;;     (identifier (letter (arbno (or letter digit))) symbol)))

;;; (define grammer-spec
;;;   '((line (arith-expr ";") current-line)
;;;     (arith-expr (arith-term (arbno add-op arith-term)) current-arith-expr)
;;;     (arith-term (arith-factor (arbno mul-op arith-factor)) current-arith-term)
;;;     (arith-factor (number) number-arith-factor)
;;;     (arith-factor (identifier) var-arith-factor)
;;;     (arith-factor ("(" arith-expr ")") paren-arith-factor)
;;;     (arith-factor ("-" arith-factor) unary-minus-arith-factor)
;;;     (add-op ("+") plus-op)
;;;     (add-op ("-") minus-op)
;;;     (mul-op ("*") mult-op)
;;;     (mul-op ("/") div-op)))

;;; (sllgen:make-define-datatypes lexical-spec grammer-spec)


;;; ; interpret the program

;;; ; we start at the line level, which leads to the arith-expr level
;;; (define value-of-line
;;;   (lambda (env)
;;;     (lambda (ln)
;;;       (cases line ln
;;;         (current-line (expression)
;;;           (value-of-arith-expr env expression)
;;;  )))))

;;; ; from the arith-expr level, we go to the arith-term level
;;; (define value-of-arith-expr
;;;   (lambda (env expression)
;;;     (cases arith-expr expression
;;;       (current-arith-expr (term ops terms)
;;;         ; we combine the value of the term with the value of the rest of the terms
;;;         (combining-value-of (value-of-term env) term (map value-of-add-op ops) terms)
;;;  ))))

;;; ; from the arith-term level, we go to the arith-factor level
;;; (define value-of-term
;;;   (lambda (env)
;;;     (lambda (term)
;;;       (cases arith-term term
;;;         (current-arith-term (factor ops factors)
;;;         ; we combine the value of the factor with the value of the rest of the factors
;;;           (combining-value-of (value-of-factor env) factor (map value-of-mul-op ops) factors)
;;;  )))))

;;; ; from the arith-factor level, we go to the number level
;;; (define value-of-factor
;;;   (lambda (env)
;;;     (lambda (factor)
;;;       (cases arith-factor factor
;;;         ; if we have a number, we just return it
;;;         (number-arith-factor (num)
;;;           num)
;;;         ; if we have a variable, we look it up in the environment
;;;         (var-arith-factor (var)
;;;           (apply-env env var))
;;;           ; if we have a parenthesized expression, we evaluate it, which will take us back to the arith-expr level
;;;         (paren-arith-factor (expr)
;;;           (value-of-arith-expr env expr))
;;;           ; if we have a unary minus, we evaluate the factor and then negate it
;;;         (unary-minus-arith-factor (factor)
;;;            (- ((value-of-factor env) factor)
;;;  ))))))

;;; ; we return the operator
;;; (define value-of-add-op
;;;   (lambda (op)
;;;     (cases add-op op
;;;       (plus-op () +)
;;;       (minus-op () -)
;;; )))

;;; ; we return the operator
;;; (define value-of-mul-op
;;;   (lambda (op)
;;;     (cases mul-op op
;;;       (mult-op () *)
;;;       (div-op () /)
;;; )))

;;; ; we combine the value of the term with the value of the rest of the terms
;;; (define combining-value-of
;;;   (lambda (value-of term ops terms)
;;;     ; we start with the value of the term
;;;     ; we then combine it with the value of the rest of the terms
;;;     ; we do this by applying the operator to the accumulator and the value of the term
;;;     (let ((combine (lambda (current-operant term accumulator)
;;;                      (current-operant accumulator (value-of term)))))
;;;       ; we fold the combine function over the list of operators and terms
;;;       (foldl combine (value-of term) ops terms)))
;;; )

;;;  (define example-env
;;;    (extend-env 'a 1
;;;      (extend-env 'b 2
;;;        (empty-env))
;;; ))

;;; (define read-eval-print
;;;   (let ((parser (sllgen:make-stream-parser lexical-spec grammer-spec)))
;;;     (lambda (env)
;;;       ((sllgen:make-rep-loop "-->" (value-of-line env) parser)))))


; Question 2

; See Let in same folder