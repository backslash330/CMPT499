#lang racket
;lab 8
; Status: Complete
(require eopl)
;Question 1
(define lexical-spec 
'((whitespace (whitespace) skip)
  (number ((or digit "-") (arbno digit)) number))
)

; Question 2
(define grammar-spec
 '((Prefix-exp ( "(" Prefix-exp ")") outerStatement)
   (Prefix-exp (number) integer)
   (Prefix-exp ("-" Prefix-exp Prefix-exp ) statement)))

; Question 3
(sllgen:make-define-datatypes lexical-spec grammar-spec)
(sllgen:list-define-datatypes lexical-spec grammar-spec)


; Question 4
(define just-scan
(sllgen:make-string-scanner lexical-spec grammar-spec))
(define scan&parse
(sllgen:make-string-parser lexical-spec grammar-spec))

; Question 5
(define (prefixEvaluator lst)
  (cases Prefix-exp lst
    (outerStatement (outerStatement5) (prefixEvaluator outerStatement5))
    (integer (integer6) integer6)
    (statement (statement7 statement8) (- (prefixEvaluator statement7) (prefixEvaluator statement8)))
    )
  )
; Question 6
(define read-eval-print
  (sllgen:make-rep-loop ">>" prefixEvaluator
                        (sllgen:make-stream-parser lexical-spec grammar-spec)))
