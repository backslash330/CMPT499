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
  ; create a new datatype for lists, so we need an empty and a cons
  (emptylist-val )
  (cons-val
    (first expval?)
    (rest expval?))
  
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

; new data types need exttactor
; expval->car : ExpVal -> ExpVal
(define (expval->car value)
  (cases expval value
    (cons-val (first rest) first)
    (else (error 'expval->car "~a is not a list!" (expval->val value)))
) )

; expval->cdr : ExpVal -> ExpVal
(define (expval->cdr value)
  (cases expval value
    (cons-val (first rest) rest)
    (else (error 'expval->cdr "~a is not a list!" (expval->val value)))
) )

; expval->empty? : ExpVal -> Boolean
(define (expval->emptylist? value)
  (cases expval value
    (emptylist-val () #t)
    (cons-val (first rest) #f)
    (else (error 'expval->empty? "~a is not a list!" (expval->val value)))
) )
; expval->list : ExpVal -> List
(define list-val
  (lambda (elements)
    (if (null? elements)
        (emptylist-val)
        (cons-val (car elements) (list-val (cdr elements))))))
