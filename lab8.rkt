#lang racket
;lab 8
; Status: Incomplete
(require eopl)
;Question 1
(define lexical-spec 
'((whitespace (whitespace) skip)
  (number ((or digit "-") (arbno digit)) number))
)

; Question 2
(define grammar-spec
 '((Prefix-list ("(" Prefix-exp ")") expression-list)
   (Prefix-exp (number) integer)
   (Prefix-exp ("-" Prefix-exp Prefix-exp ) statement)))
; Question 3
(sllgen:list-define-datatypes lexical-spec grammar-spec)


; Question 4
(define list-the-datatypes
(lambda ()
(sllgen:list-define-datatypes lexical-spec grammar-spec)))
; call listpt
(list-the-datatypes)
; Question 5
(define (prefixEvaluator expr)
  (cases Prefix-list expr
    [(integer? n) n]
    [(list '- e1 e2)
     (- (prefixEvaluator e1)
        (prefixEvaluator e2))]
    [else (error "Invalid expression")]))

; Question 6
;(define read-eval-print
;(sllgen:make-rep-loop ">> " value-of--program
;(sllgen:make-stream-parser lexical-spec grammar-spec)))