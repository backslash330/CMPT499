;##########################################################
;#                                                        #
;# the LET interpreter                                    #
;# ====================================================== #
;# CMPT 340: Assignment 5                                 #
;# YOUR NAME                                              #
;# ID NUMBER                                              #
;##########################################################

#lang racket
(require  eopl
          "datatypes.rkt")
(provide (all-defined-out))

;;;;;;;;;;;;;;;; environment constructors and observers ;;;;;;;;;;;;;;;;

(define-datatype environment environment?
  (empty-env)
  (extend-env (saved-var symbol?)
              (saved-val expval?)
              (saved-env environment?)))

(define (apply-env env search-var)
  (if (environment? env)
    (cases environment env
      (empty-env () (error 'apply-env "No binding for ~v in the Environment" search-var) )
      (extend-env (saved-var saved-val saved-env)
        (if (eqv? saved-var search-var)
          saved-val
          (apply-env saved-env search-var))))
    (error 'apply-env "Expected an environment.")))  
; we need to add extend-env* for lists of variables
(define (extend-env* vars vals env)
  (if (null? vars)
    env
    (extend-env (car vars) (car vals) (extend-env* (cdr vars) (cdr vals) env))))

; for ribcage 
;;;;;;;;;;;;;;;;;;; initial environment ;;;;;;;;;;;;;;;;;;;

;; init-env : () -> Env
;; usage: (init-env) = [i=1, v=5, x=10]
;; (init-env) builds an environment in which i is bound to the
;; expressed value 1, v is bound to the expressed value 5, and x is
;; bound to the expressed value 10.
;; Page: 69

(define init-env 
  (lambda ()
    (extend-env 
     'i (num-val 1)
     (extend-env
      'v (num-val 5)
      (extend-env
       'x (num-val 10)
       (empty-env))))))  