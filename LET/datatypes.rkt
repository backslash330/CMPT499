;##########################################################
;#                                                        #
;# the LET interpreter                                    #
;# ====================================================== #
;# CMPT 340: Assignment 5                                 #
;# YOUR NAME                                              #
;# ID NUMBER                                              #
;##########################################################

#lang racket
(require eopl)
(provide (all-defined-out))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;    Modify the definitions of expval as needed         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;; expressed  values ;;;;;;;;;;;;;;;;;;;;

;;; an expressed value is either a number, a boolean.

(define-datatype expval expval?
  (num-val
    (value number?))
  (bool-val
    (boolean boolean?))
    ; new data types go here
    ;;; (list-val
    ;;;  (lst list?))
)

;;; extractors:

;; expval->val : ExpVal -> SchemeVal
;; Used for printing values.
;; Modify this to enable "pretty printing" of custom datatypes.
(define (expval->val value)
  (cases expval value
    [ bool-val (bool) bool ]
    [ num-val (num) num ]
   ; [list-val (lst) (map expval->val lst)]
    [ else value ]
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

; ned data types need exttactor
