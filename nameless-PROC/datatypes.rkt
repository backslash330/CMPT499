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
          "language.rkt")

(provide (all-defined-out))

;;;;;;;;;;;;;;;;;;;; expressed  values ;;;;;;;;;;;;;;;;;;;;
;;; an expressed value is either a number, a boolean, or a proc

(define-datatype expval expval?
  (num-val
    (value number?))
  (bool-val
    (boolean boolean?))
  (proc-val
    (proc proc?))
  )

;;; extractors:

;; expval->proc : ExpVal -> Proc
(define (expval->proc value)
    (cases expval value
      (proc-val (proc) proc)
      (else (error 'expval->proc "~a is not a procedure!" (expval->val value)))
) )

;; expval->num : ExpVal -> Int
(define (expval->num value) 
  (cases expval value
    (num-val (num) num)
    (else (error 'expval->num "~a is not an Integer!" (expval->val value)))
) )

;; expval->bool : ExpVal -> Bool
(define (expval->bool value) 
  (cases expval value
    (bool-val (bool) bool)
    (else (error 'expval->bool "~a is not an Boolean!" (expval->val value)))
) )

;; expval->val : ExpVal -> SchemeVal
;; Used for printing values.
;; Modify this to enable "pretty printing" of custom datatypes.
(define (expval->val value)
  (cases expval value
    [ bool-val (bool) bool ]
    [ num-val (num) num ]
    [ proc-val (proc) "#<procedure>" ]
    [ else value ]
) )

(define (nameless-env? env) ((listof expval?) env))

(define-datatype proc proc?
  [ procedure 
    (body expression?)
    (env  nameless-env?) ]
)