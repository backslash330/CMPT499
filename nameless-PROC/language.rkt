;##########################################################
;#                                                        #
;# the nameless-PROC interpreter                          #
;# ====================================================== #
;# CMPT 340: Assignment 6                                 #
;# YOUR NAME                                              #
;# ID NUMBER                                              #
;##########################################################

#lang racket

(require eopl)

(provide (all-defined-out))

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

    ;;; [ expression
    ;;;   ("let" identifier "=" expression "in" expression)
    ;;;   let-exp ]    
    [expression ("let" (arbno identifier "=" expression) "in" expression) let-exp]

    ;;; [ expression
    ;;;   ("proc" "(" identifier ")" expression)
    ;;;   proc-exp ]   
    [expression ("proc" "(" (separated-list identifier ",") ")" expression) proc-exp]

    ;;; [ expression
    ;;;   ("(" expression expression ")")
    ;;;   call-exp ]
    [expression ("(" expression (arbno expression) ")") call-exp]
    
    [ expression
      ("%lexref" number)
      nameless-var-exp ]
    
    ; this also needs to change because it also needs to get to change an arb no of expressions
    ;
    [ expression
      ("%lexlet" expression "in" expression)
      nameless-let-exp ]

    [ expression
      ("%lexproc" expression)
      nameless-proc-exp ]
) )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;        You do not need to modify below                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;; SLLGEN  boilerplate ;;;;;;;;;;;;;;;;;;;

(sllgen:make-define-datatypes the-lexical-spec the-grammar)

(define (show-the-datatypes)
  (sllgen:list-define-datatypes the-lexical-spec the-grammar))

(define scan&parse
  (sllgen:make-string-parser the-lexical-spec the-grammar))

(define just-scan
  (sllgen:make-string-scanner the-lexical-spec the-grammar))

(define stream-parser
  (sllgen:make-stream-parser the-lexical-spec the-grammar))