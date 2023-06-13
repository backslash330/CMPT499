;##########################################################
;#                                                        #
;# the nameless-PROC interpreter                          #
;# ====================================================== #
;# CMPT 340: Assignment 6                                 #
;# YOUR NAME                                              #
;# ID NUMBER                                              #
;##########################################################

#lang racket

(require  eopl
          "translator.rkt"
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
      (value-of exp1 (init-nameless-env)))
) )

;; value-of : Exp * Env -> ExpVal
;; Page: 71
(define (value-of exp env)
  (cases expression exp

    ;;;;;;;;;;;; Do NOT change these variants  ;;;;;;;;;;;;
    [ const-exp (n)  (num-val n) ]

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

    [ call-exp (rator rand)
      (apply-procedure 
        (expval->proc (value-of rator env)) 
        (value-of rand env))]

    ;;;;;;;;;;;;; These Variants MUST be changed ;;;;;;;;;;

    ; Replace with nameless-var-exp
    ;;; [ nameless-var-exp (depth)  (apply-nameless-env env depth) ]
    ; the vars are now a list so thesame issue as let 
    [ nameless-var-exp (depth)
    ; we need to get the value of the depth in a  
      (apply-nameless-env env depth) ]

    ; Replace with nameless-let-exp
    ;;; [ nameless-let-exp (exp1 body)  
    ;;;   (let ((val1 (value-of exp1 env)))
    ;;;     (value-of body (extend-nameless-env val1 env) ) ) ]   
    ; the expressions are now a list of expressions
    ;;; [ nameless-let-exp (expressions body)  
    ;;;   (let ((vals (map (lambda (exp) (value-of exp env)) expressions)))
    ;;;     (value-of body (extend-nameless-env-list vals env) ) ) ]
      ;;; (map (lambda (exp) (value-of exp (init-nameless-env))) (list (const-exp 5) (const-exp 3)))
      ;;; (list (num-val 5) (num-val 3))
      ; vals is turned into a list of expvals
      ; we then need to use apply-nameless-env to apply that expval to it's appropriate nameless val
      ; we can do this by using map and apply-nameless-env
    [ nameless-let-exp (expressions body)  
      ; we need to reverse the list of expressions so that the first expression is the first in the list
      (let ((vals (reverse (map (lambda (exp) (value-of exp env)) expressions))))
        (value-of body (extend-nameless-env-list  vals env) ) ) ]

    ; Replace with nameless-proc-exp  
    [ nameless-proc-exp (body)
      (proc-val (procedure body env))]

    ; Do not modify the ELSE
    [ else (error 'value-of "INVALID AST") ]
) )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;        Apply Procedures                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (apply-procedure proc1 arg) 
  (cases proc proc1
    [procedure (body env)
      (value-of body (extend-nameless-env arg env))
] ) )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;        You do not need to modify below                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; run : String -> ExpVal
;;;  DO NOT MODIFY
(define (run string)
  (value-of-program
    (translation-of-program
      (scan&parse string)
) ) )


;;; read-eval-print -> ()
;;;  Using readline to provide a "nice" CLI
;;;  DO NOT MODIFY
(define (read-eval-print)
  (make-readline-repl 
    "-> "
    (lambda(pgm) (expval->val (value-of-program (translation-of-program pgm)))) 
    stream-parser
) )

;(define (instrumentedEval pgm)
;  (printf "~%# NAMED AST:~%~a~%~%" pgm)
;  (printf "# TRANSLATED AST:~%~a~%~%" (translation-of-program pgm))
;  (value-of-program (translation-of-program pgm))
;)