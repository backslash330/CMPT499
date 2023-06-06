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

    [ call-exp (named-rator named-rand) 
      (call-exp (translation-of named-rator senv) 
                (translation-of named-rand senv) ) ]
    
    [ proc-exp (var body)  
      (nameless-proc-exp (translation-of body (extend-senv var senv))) ]

    [ var-exp (var) (nameless-var-exp (apply-senv senv var)) ]
    ; need to change what let exp does
    ; ; named exp is  now a list
    [ let-exp (var named-exp1 body) 
      (nameless-let-exp
         (translation-of named-exp1 senv) 
         (translation-of body (extend-senv var senv))) ]

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

(define (extend-senv vars senv) (cons (list vars 'value) senv) )

;;; (define (apply-senv senv var)
;;;   (cond 
;;;     ((null? senv) (error 'apply-senv "NO BINDING FOR VARIABLE"))
;;;     ((eqv? var (car senv)) 0)
;;;     (else (+ 1 (apply-senv (cdr senv) var)))
;;; ) )
(define apply-senv
  (lambda (senv var)
    (define (apply-senv-sub pos vars)
      (if (null? vars)
          (let ((result (apply-senv (cdr senv) var)))
            (cons (+ (car result) 1) (cdr result)))
          (if (eqv? (car vars) var)
              (list 0 pos (cadar senv))
              (apply-senv-sub (+ pos 1) (cdr vars)))))
    (if (null? senv)
        (error 'apply-senv "Unbound variable: " var)
        (apply-senv-sub 0 (caar senv)))))

        
(define (init-senv)
  (extend-senv 'i (extend-senv 'v (extend-senv 'x (empty-senv))))
)