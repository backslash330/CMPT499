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

;;;;;;;;;;;;;;;; procedures ;;;;;;;;;;;;;;;;

;; proc? : SchemeVal -> Bool
;; procedure : Var * Exp * Env -> Proc
(define-datatype proc proc?
  (procedure
    (bvar symbol?)
    (body expression?)
    (env environment?)))

;; Page: 86
(define-datatype environment environment?
  (empty-env)
  (extend-env 
    (saved-var  symbol?)
    (saved-val  expval?)
    (saved-env  environment?))
  (extend-env-rec
    (proc-name  symbol?)
    (bound-var  symbol?)
    (proc-body  expression?)
    (env        environment?))
  ; add list variant
  (extend-env-list
    (saved-var  (listof symbol?))
    (saved-val  (listof expval?))
    (saved-env  environment?))
)