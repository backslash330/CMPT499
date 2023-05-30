#lang racket
(require  eopl
          "language.rkt" 
          "datatypes.rkt"
          "environment.rkt"
          "readline-repl.rkt")
(provide (all-defined-out))

;;;;;;;;;;;;;;;;;;;;; the interpreter ;;;;;;;;;;;;;;;;;;;;;

;; value-of-program : Program -> ExpVal
;; Page: 71
(define (value-of-program pgm)
  (cases program pgm
    (a-program (exp1)
      (value-of exp1 (init-env)))
) )

;; value-of : Exp * Env -> ExpVal
;; Page: 71
(define (value-of exp env)
  (cases expression exp

    [ const-exp (n)  (num-val n) ]

    [ var-exp (var)  (apply-env env var) ]

    [ diff-exp (exp1 exp2)  
      (num-val
        (- (expval->num (value-of exp1 env))
           (expval->num (value-of exp2 env)) ) ) ]

    [ zero?-exp (exp1)  
      (bool-val
        (zero? (expval->num (value-of exp1 env) ) ) ) ]

    [ if-exp (exp1 exp2 exp3)  
      (let ((val1 (value-of exp1 env)))
        (if (expval->bool val1)      
          (value-of exp2 env)
          (value-of exp3 env) ) ) ]

    [ let-exp (var exp1 body)  
      (let ((val1 (value-of exp1 env)))
        (value-of body (extend-env var val1 env) ) ) ]   
  
    [ proc-exp (var body)
      (proc-val (procedure var body env))]

    [ call-exp (rator rand)
      (apply-procedure 
        (expval->proc (value-of rator env)) 
        (value-of rand env))]
) )

(define (apply-procedure proc arg) (proc arg) )

(define (procedure var body env) 
  (lambda(arg) (value-of body (extend-env var arg env)) ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;        You do not need to modify below                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; run : String -> ExpVal
;;;  DO NOT MODIFY
(define (run string)
  (value-of-program (scan&parse string))
)

;;; read-eval-print -> ()
;;;  Using readline to provide a "nice" CLI
;;;  DO NOT MODIFY
(define (read-eval-print)
  (make-readline-repl 
    "-> "
    (lambda(exp) (expval->val (value-of-program exp))) 
    stream-parser
) )
