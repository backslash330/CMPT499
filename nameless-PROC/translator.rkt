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
          "language.rkt" )

(provide (all-defined-out))

;;;;;;;;;;;;;; Lexical-Address Translator ;;;;;;;;;;;;;;;
; page 97

(define (translation-of exp senv)

  (cases expression exp 

    [ const-exp (num) (const-exp num) ]
  
    [ diff-exp (named-exp1 named-exp2) 
        (diff-exp (translation-of named-exp1 senv) 
                  (translation-of named-exp2 senv)) ]

    [ zero?-exp (named-exp)  
      (zero?-exp  (translation-of named-exp senv) ) ]
        
    [ if-exp (named-exp1 named-exp2 named-exp3)   
      (if-exp (translation-of named-exp1 senv)
              (translation-of named-exp2 senv)
              (translation-of named-exp3 senv)) ]

    ;;; [ call-exp (named-rator named-rand) 
    ;;;   (call-exp (translation-of named-rator senv) 
    ;;;             (translation-of named-rand senv) ) ]
    ; a call expression now has multiple arguments
    ; for example, (call-exp (proc-exp (list (var-exp 'x) (var-exp 'y)) (diff-exp (var-exp 'x) (var-exp 'y))) (list (const-exp 5) (const-exp 6)))
    ; remember we also need to handle nested calls
    [ call-exp (named-rator named-rands)
      (call-exp (translation-of named-rator senv)
                (map (lambda (rand) (translation-of rand senv)) named-rands)
      )
    ]

    ;;; [ proc-exp (var body)  
    ;;;   (nameless-proc-exp (translation-of body (extend-senv var senv))) ]
    ; this needs to be changed since proc-exp now have multiple vars
    ; Expression ::= proc ( {Identifier}∗(,) ) Expression
    ; for example,  (proc (x,y) -(x,y)  5 6)
    [ proc-exp (vars body)  
      (nameless-proc-exp (translation-of body (extend-senv* vars senv)))]


    [ var-exp (var) (nameless-var-exp (apply-senv senv var)) ]
    
    ;;; [ let-exp (var named-exp1 body) 
    ;;;   (nameless-let-exp
    ;;;      (translation-of named-exp1 senv) 
    ;;;      (translation-of body (extend-senv var senv))) ]
    ; this needs to be changed since let-exp now have multiple vars and multiple expressions
    ; for example,  (a-program (let-exp '(x) (list (const-exp 5)) (diff-exp (var-exp 'x) (const-exp 2))))
    ; needs to translated to (nameless-let-exp (const-exp 5) (diff-exp (nameless-var-exp 0) (const-exp 2))))
    ; likewise when we have multiple vars
    ; example
    ; original: (a-program (let-exp '(x y) (list (const-exp 5) (const-exp 3)) (diff-exp (var-exp 'x) (var-exp 'y))))
    ; output: (nameless-let-exp (list (const-exp 5) (const-exp 3)) (diff-exp (nameless-var-exp 1) (nameless-var-exp 0))))
    [let-exp (vars exps body)
      (nameless-let-exp
        ; the first argument is a list of the translations of each expression in the list
        (map (lambda (exp) (translation-of exp senv)) exps)
        ; the second argument is the translation of the body with the static environment extended with the variables
        (translation-of body (extend-senv* vars senv)))
      
    ]

    [ else (error 'translation-of "INCORRECT AST") ]
  )
)

(define (translation-of-program pgm)
  (cases program pgm
    (a-program (exp1)
      (a-program (translation-of exp1 (init-senv))))
))

;;;;;;;;;;;;;;;;;; static environments ;;;;;;;;;;;;;;;;;;
; page 95

(define (empty-senv) '())

(define (extend-senv var senv) (cons var senv) )

; extend-senv* takes a list of variables and a static environment
; and returns a new static environment with the variables added to it
(define (extend-senv* vars senv)
  (cond
    [(null? vars) senv]
    [else (extend-senv* (cdr vars) (extend-senv (car vars) senv))]
  )
)

(define (apply-senv senv var)
  (cond 
    ((null? senv) (error 'apply-senv "NO BINDING FOR VARIABLE"))
    ((eqv? var (car senv)) 0)
    (else (+ 1 (apply-senv (cdr senv) var)))
) )

(define (init-senv)
  (extend-senv 'i (extend-senv 'v (extend-senv 'x (empty-senv))))
)
