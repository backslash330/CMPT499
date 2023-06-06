#lang racket
(require  eopl
          "datatypes.rkt"
          "language.rkt")
(provide (all-defined-out))


;;;;;;;;;;;;;;;; environment constructors and observers ;;;;;;;;;;;;;;;;

;; Page: 86
;this is a reference representation of a environment, we need to replace it with a ribcage representation
;;; (define (apply-env env search-var)
;;;   (cases environment env
;;;     [ empty-env ()
;;;       (error 'apply-env "No binding for ~s" search-var) ]
;;;     [ extend-env (var val saved-env)
;;;       (if (eqv? search-var var)
;;;         val
;;;         (apply-env saved-env search-var) ) ]
;;;     [ extend-env-rec (p-name b-var p-body saved-env)
;;;         (if (eqv? search-var p-name)
;;;           (proc-val (procedure b-var p-body env))
;;;           (apply-env saved-env search-var)) ]
;;; ) )

; needed to change for question 2-4, not sure if needed to be the same for 1
(define apply-env
  (lambda (env search-sym)
    (cases environment env
      [empty-env () (eopl:error 'apply-env "No binding for ~s" search-sym)]
      [extend-env (var val saved-env) (if (eqv? search-sym var)
                                          val
                                          (apply-env saved-env search-sym))]
      [extend-env-rec (p-names b-vars p-bodies saved-env) (let loop ([p-names p-names]
                                                                     [b-vars b-vars]
                                                                     [p-bodies p-bodies])
                                                            (if (null? p-names)
                                                                (apply-env saved-env search-sym)
                                                                (if (eqv? search-sym (car p-names))
                                                                    (proc-val (procedure (car b-vars)
                                                                                         (car p-bodies)
                                                                                         env))
                                                                    
                                                                    (loop (cdr p-names)
                                                                          (cdr b-vars)
                                                                          (cdr p-bodies)))))])))
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