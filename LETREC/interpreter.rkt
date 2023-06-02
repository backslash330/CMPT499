#lang racket
(require eopl)
(require  "language.rkt" 
          "datatypes.rkt"
          "environment.rkt"
          "readline-repl.rkt")          
(provide (all-defined-out))

;;;;;;;;;;;;;;;;;;;;; the interpreter ;;;;;;;;;;;;;;;;;;;;;

;; value-of-program : Program -> ExpVal
;; Page: 71
(define value-of-program 
  (lambda (pgm)
    (cases program pgm
      (a-program (exp1)
        (value-of exp1 (init-env)))
)))

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

    ;;; [ let-exp (var exp1 body)  
    ;;;   (let ((val1 (value-of exp1 env)))
    ;;;     (value-of body (extend-env var val1 env) ) ) ]   
    ; add arbitary let
      (let*-exp (vars exprs body)
        (let ((vals (map (lambda (expr) (value-of expr env)) exprs)))
          (value-of body (extend-env* vars vals env))))
          
    ;;; [ proc-exp (var body)
    ;;;   (proc-val (procedure var body env)) ]
    [ proc-exp (vars body)
      (proc-val (procedure vars body env)) ]
    
    ;;; [ call-exp (rator rand)
    ;;;   (apply-procedure 
    ;;;     (expval->proc (value-of rator env)) 
    ;;;     (value-of rand env)) ]

    [ call-exp (rator rands) 
      (let ([proc (expval->proc (value-of rator env))]
        [args (map (lambda (rand)(value-of rand  env)) rands)])
            (apply-procedure proc args))]
        
    [ letrec-exp (p-names b-vars p-bodies letrec-body) (value-of letrec-body
                                                                  (extend-env-rec p-names b-vars p-bodies env)) ]
) )

;; apply-procedure : Proc * ExpVal -> ExpVal
(define (apply-procedure proc1 args) ; changed to args
  (cases proc proc1
    ; we need to change apply-procedure to handle arbitary number of arguments
    ;;; [ procedure (vars body saved-env)
    ;;;   (value-of body (extend-env var arg saved-env)) ]
    [ procedure (vars body saved-env)
      (let loop ([env saved-env] [vars vars] [args args])
        (if (null? vars)
            (value-of body env)
            (loop (extend-env (car vars) (car args) env)
                  (cdr vars)
                  (cdr args)))) ]
) )


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
