#lang racket
(require  eopl
          "datatypes.rkt"
          "language.rkt")
(provide (all-defined-out))


;;;;;;;;;;;;;;;; environment constructors and observers ;;;;;;;;;;;;;;;;



; write a new version of apply-env that uses the ribcage representation
; this means that we need to make sure that no bound variables fall off in the recursive case
(define (apply-env env search-var)
  (cases environment env
    [ empty-env ()
      (error 'apply-env "No binding for ~s" search-var) ]
    [ extend-env (var val saved-env)
      (if (eqv? search-var var)
        val
        (apply-env saved-env search-var) ) ]
          [extend-env-rec (p-names b-vars bodies saved-env)
                            (apply-extend-env-rec
                             env p-names b-vars bodies saved-env search-var)]))


(define apply-extend-env-rec
  (lambda (env p-names b-vars bodies saved-env search-var)
    (if (null? p-names)
        (apply-env saved-env search-var)
        (if (eqv? search-var (car p-names))
            (proc-val (procedure (car b-vars) (car bodies) env))
            (apply-extend-env-rec
             env
             (cdr p-names) (cdr b-vars) (cdr bodies) saved-env
             search-var)))))

(define (extend-env* vars vals env)
  (if (null? vars)
    env
    (extend-env (car vars) (car vals) (extend-env* (cdr vars) (cdr vals) env))))

; remember that the following will be helpful:
(define (list-index pred lst)
  (define (list-index-helper pred lst index)
    (cond ((null? lst) #f) 
          ((pred (car lst)) index) 
          (else (list-index-helper pred (cdr lst) (+ index 1)))))
  
  (cond ((not (procedure? pred)) (error "pred must be a procedure"))
        ((not (list? lst)) (error "lst must be a list"))
        ((number? (list-index-helper pred lst 0)) (list-index-helper pred lst 0))
        (else #f)))

;;; (define empty-env (lambda () '()))



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