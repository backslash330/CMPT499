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
          "datatypes.rkt")

(provide (all-defined-out))

;;;;;;;;;;;;;;;; environment constructors and observers ;;;;;;;;;;;;;;;;

(define (empty-nameless-env) '())
(define (extend-nameless-env value env) (cons value env))
(define (apply-nameless-env env depth) (list-ref env depth))

;;;;;;;;;;;;;;;;;;; initial environment ;;;;;;;;;;;;;;;;;;;

;; init-env : () -> Env
;; usage: (init-env) = [i=1, v=5, x=10]
;; (init-env) builds an environment in which i is bound to the
;; expressed value 1, v is bound to the expressed value 5, and x is
;; bound to the expressed value 10.
;; Page: 69

(define (init-nameless-env)
  (extend-nameless-env 
    (num-val 1)
    (extend-nameless-env
      (num-val 5)
      (extend-nameless-env
        (num-val 10)
        (empty-nameless-env)
) ) ) )
