#lang racket
;lab 8
; Status: Incomplete
(require eopl)
;Question 1
(define lexical-spec 
'((whitespace (whitespace) skip)
 (comment ("%" (arbno (not #\newline))) skip)
 (minus ((char #\-)) symbol)
 (number (digit (arbno digit)) number)
 (open-paren (char #\() symbol)
 (close-paren (char #\)) symbol)))

; Question 2
(define grammar-spec
 '((Prefix-list ("(" Prefix-exp ")") expression-list)
   (Prefix-exp (number) integer)
   (Prefix-exp ("-" Prefix-exp Prefix-exp ) statement)))
; Question 3
; (sllgen:list-define-datatypes lexical-spec grammar-spec)


; Question 4
(define list-the-datatypes
(lambda ()
(sllgen:list-define-datatypes lexical-spec grammar-spec)))

; Question 5
(define (prefixEvaluator expr)
  (cond
    ((integer? expr) expr)
    ((list? expr)
     (let ((operator (car expr))
           (operands (cdr expr)))
       (case operator
         ((-)
          (if (null? operands)
              (error "Invalid expression")
              (- (prefixEvaluator (car operands))
                 (prefixEvaluator (cadr operands)))))
         (else (error "Invalid operator")))))
    (else (error "Invalid expression"))))

; Question 6
(define read-eval-print
(sllgen:make-rep-loop ">> " value-of--program
(sllgen:make-stream-parser scanner-spec-1 grammar-1)))