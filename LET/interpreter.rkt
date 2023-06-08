;##########################################################
;#                                                        #
;# the LET interpreter                                    #
;# ====================================================== #
;# CMPT 340: Assignment 5                                 #
;# Nicholas Almeida                                       #
;# ID NUMBER: 200385                                      #
;##########################################################

#lang racket
(require  eopl
          "language.rkt" 
          "datatypes.rkt"
          "environment.rkt"
          "readline-repl.rkt")
(provide (all-defined-out))

;;;;;;;;;;;;;;;;;;;;; The Interpreter ;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;       Modify the following procedures                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; value-of-program : Exp -> ExpVal
(define (value-of-program exp) 
  (cases program exp
    [ a-program (exp1)
      (value-of exp1 (init-env)) ]
) )

;; value-of : Exp * Env -> ExpVal
(define (value-of exp env)
  (cases expression exp

    [ const-exp (n)  (num-val n) ]

    [ var-exp (var)  (apply-env env var) ]

    [ diff-exp (exp1 exp2)  
      (num-val
        (- (expval->num (value-of exp1 env))
           (expval->num (value-of exp2 env)) ) ) ]

    [ zero?-exp (exp1)  
      (bool-val
        (zero? (expval->num (value-of exp1 env) ) ) ) ]

    [ if-exp (exp1 exp2 exp3)  
      (let ((val1 (value-of exp1 env)))
        (if (expval->bool val1)      
          (value-of exp2 env)
          (value-of exp3 env) ) ) ]
; commented out the old let expression
    ;;; [ let-exp (var exp1 body)  
    ;;;   (let ((val1 (value-of exp1 env)))
    ;;;     (value-of body (extend-env var val1 env) ) ) ]   

    ; we add the case here
    ;;;  [minus-exp (exp)
    ;;;            (num-val
    ;;;             (- 0 (expval->num num))
    ;;;             )
    ;;;             ]
    [minus-exp (exp)
               (num-val
                (- 0 (expval->num (value-of exp env)))
                )
               ]

    [plus-exp (exp1 exp2)
              (num-val
               (+ (expval->num (value-of exp1 env))
                  (expval->num (value-of exp2 env)))
               )
              ]

    [mult-exp (exp1 exp2)
              (num-val
               (* (expval->num (value-of exp1 env))
                  (expval->num (value-of exp2 env)))
               )
              ]

    [div-exp (exp1 exp2)
              (num-val
                (/ (expval->num (value-of exp1 env))
                  (expval->num (value-of exp2 env)))
                )
              ]
    ; Question 2c
    ;;; [cons-exp (exp1 exp2)
    ;;;           (cons-val
    ;;;                  (value-of exp1 env)
    ;;;                   (value-of exp2 env)
    ;;;             )
    ;;;           ]
    ;;; [car-exp (exp)
    ;;;          (expval->car
    ;;;            (value-of exp env)
    ;;;           )
    ;;;          ]
    ;;; [cdr-exp (exp)
    ;;;           (expval->cdr
    ;;;             (value-of exp env)
    ;;;             )
    ;;;           ]
    ;;; [null?-exp (exp)
    ;;;            ( bool-val
    ;;;             (expval->empty? (value-of exp env))
    ;;;             )
    ;;;            ]
          (cons-exp (exp1 exp2)
        (let ((val1 (value-of exp1 env))
              (val2 (value-of exp2 env)))
          (cons-val val1 val2)))
      (car-exp (exp1)
        (let ((val1 (value-of exp1 env)))
          (expval->car val1)))
      (cdr-exp (exp1)
        (let ((val1 (value-of exp1 env)))
          (expval->cdr val1)))
      (null?-exp (exp1)
        (let ((val1 (value-of exp1 env)))
          (let ((bool1 (expval->emptylist? val1)))
            (bool-val bool1))))
    ;;; [emptylist-exp ()
    ;;;                 (empty-val)
    ;;;                 ]
    
    ;;; ;Question 2c add the list
    ;;; [list-exp (expressions)
    ;;;           ; we need to get the value of each expression, so we use map
    ;;;           (list-value
    ;;;            (map (lambda (exp) (value-of exp env)) expressions)
    ;;;            )
    ;;;           ]
      (emptylist-exp ()
        (emptylist-val))
    ; we aren't even getting here, which is weird
      (list-exp (exprs)
        (list-val (map (lambda (expr) (value-of expr env)) exprs)))

  (let*-exp (vars exprs body)
        (let ((vals (map (lambda (expr) (value-of expr env)) exprs)))
          (value-of body (extend-env* vars vals env))))

) )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;        You do not need to modify below                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
;; run : String -> ExpVal
;;;  DO NOT MODIFY
(define (run string)
  (value-of-program (scan&parse string))
)

;;; read-eval-print -> ()
;;;  Using readline to provide a "nice" CLI
;;;  DO NOT MODIFY
(define (read-eval-print)
  (make-readline-repl 
    "-> "
    (lambda(exp) (expval->val (value-of-program exp))) 
    stream-parser
) )
