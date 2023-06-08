;##########################################################
;#                                                        #
;# the LET interpreter                                    #
;# ====================================================== #
;# CMPT 340: Assignment 5                                 #
;# Nicholas Almeida                                       #
;# ID NUMBER: 200385                                      #
;##########################################################

#lang racket
(require eopl)
(provide (all-defined-out))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Modify the LET lexical & grammaratical specification  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;; lexical specification ;;;;;;;;;;;;;;;;;;

(define the-lexical-spec
  '(
    [ whitespace (whitespace) skip ]
    [ comment ("%" (arbno (not #\newline))) skip ]
    [ identifier
      (letter (arbno (or letter digit "_" "-" "?")))
      symbol ]
    [ number (digit (arbno digit)) number ]
    [ number ("-" digit (arbno digit)) number ]
) )

;;;;;;;;;;;;;;;; grammatical specification ;;;;;;;;;;;;;;;;

(define the-grammar
  '(

    [ program (expression) a-program ]

    [ expression (number) const-exp ]
    
    [ expression
      ("-" "(" expression "," expression ")")
      diff-exp ]

    [ expression
      ("zero?" "(" expression ")")
      zero?-exp ]

    [ expression
      ("if" expression "then" expression "else" expression)
      if-exp ]

    [ expression (identifier) var-exp ]
    ; commented out for question 2f
    ;;; [ expression
    ;;;   ("let" identifier "=" expression "in" expression)
    ;;;   let-exp ]    
      ; syntax changes go here
    [ expression
      ("minus" "(" expression ")") minus-exp ]
    [ expression
      ("+" "(" expression "," expression ")" ) plus-exp ]
    [ expression
      ("*" "(" expression "," expression ")" ) mult-exp ]
    [ expression
      ("/" "(" expression "," expression ")" ) div-exp ]
    [expression 
      ("cons" "(" expression "," expression ")" ) cons-exp ]
    [expression 
      ("car" "(" expression ")" ) car-exp ]
    [expression 
      ("cdr" "(" expression ")" ) cdr-exp ]
    [expression 
      ("null?" "(" expression ")" ) null?-exp ]
    [expression 
      ("emptylist") emptylist-exp ]
    [expression
      ("list" "(" (separated-list expression ",") ")") list-exp ]
    ; arbatery number of let statments
    [expression
      ("let"(arbno identifier "=" expression) "in" expression) let*-exp ]
) )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;        You do not need to modify below                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;; SLLGEN  boilerplate ;;;;;;;;;;;;;;;;;;;

(sllgen:make-define-datatypes the-lexical-spec the-grammar)

(define show-the-datatypes
  (lambda () (sllgen:list-define-datatypes the-lexical-spec the-grammar)))

(define scan&parse
  (sllgen:make-string-parser the-lexical-spec the-grammar))

(define just-scan
  (sllgen:make-string-scanner the-lexical-spec the-grammar))

(define stream-parser
  (sllgen:make-stream-parser the-lexical-spec the-grammar))
