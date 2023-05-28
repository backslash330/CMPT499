; Lab 7
; Status Complete

#lang racket
(require eopl)


;Question 1

(define-datatype lc-exp lc-exp?
  (var-exp (var symbol?))
  (lambda-exp (bound-vars (listof symbol?)) (body lc-exp?))
  (app-exp (rator lc-exp?) (rands (listof lc-exp?))))


(define parse-expression 
    (lambda (sexp)
        (cond
        [(symbol? sexp) (var-exp sexp)]
        [(list? sexp)
         (cond
             [(eq? (first sexp) 'lambda)
            (lambda-exp (second sexp) (parse-expression (third sexp)))]
             [else
            (app-exp (parse-expression (first sexp))
                     (map parse-expression (rest sexp)))] )] )))

; Question 2

(define unparse
  (lambda (expression)
    (cases lc-exp expression
      (var-exp (var) (symbol->string var))
      (lambda-exp (bound-vars body)
        (string-append "proc " (string-join (map symbol->string bound-vars) " ") " => " (unparse body)))
      (app-exp (rator rands)
        (string-append (unparse rator) " (" (string-join (map unparse rands) " ") ")")))))
