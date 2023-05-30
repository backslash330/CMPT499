#lang racket
(require  eopl
          "datatypes.rkt"
          "language.rkt")
(provide (all-defined-out))


;;;;;;;;;;;;;;;; environment constructors and observers ;;;;;;;;;;;;;;;;

;; Page: 86
(define (apply-env env search-var)
  (cases environment env
    [ empty-env ()
      (error 'apply-env "No binding for ~s" search-var) ]
    [ extend-env (var val saved-env)
      (if (eqv? search-var var)
        val
        (apply-env saved-env search-var) ) ]
    [ extend-env-rec (p-name b-var p-body saved-env)
        (if (eqv? search-var p-name)
          (proc-val (procedure b-var p-body env))
          (apply-env saved-env search-var)) ]
    ; add list case
    [ extend-env-list (vars vals saved-env)
      ; if there are no more vars, then there are no more vals
      (if (null? vars)
        (error 'apply-env "No binding for ~s" search-var)
        ; if the first var is the search var, then return the first val
        (if (eqv? search-var (car vars))
          (car vals)
          ; otherwise, search the rest of the list
          (apply-env (extend-env-list (cdr vars) (cdr vals) saved-env) search-var)))]
) )


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