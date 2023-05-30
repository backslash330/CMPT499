#lang racket
(require eopl)

; question 2
; ask about why var-exp fails in the original code
;(define (parse-expression datum)
;  (with-handlers ([exn:fail? (lambda (exn)
;                               (raise-arguments-error
;                                'parse-expression
;                                "Invalid LcExp"
;                                "LcExp" datum))])
;    (cond
;      [(symbol? datum) (var-exp datum)]
;      [(and (list? datum) (eqv? (car datum) 'lambda))
;       (lambda-exp (caadr datum)
;                   (parse-expression (caddr datum)))]
;      [(list? datum)
;       (app-exp (parse-expression (car datum))
;                (parse-expression (cadr datum)))])))

; Question 3b
; needs error checking

(define-datatype prefix-exp prefix-exp?
  (const-exp (num integer?))
  (diff-exp (operand1 prefix-exp?)
            (operand2 prefix-exp?)))

(define (parse-prefix-exp lst)
  (define (parse-rec lst)
    (if (eqv? '- (car lst))
        (let ((left-ret (parse-rec (cdr lst))))
          (let ((right-ret (parse-rec (cadr left-ret))))
            (list (diff-exp (car left-ret)
                            (car right-ret))
                  (cadr right-ret))))
        (list (const-exp (car lst))
              (cdr lst))))
  (car (parse-rec lst)))

; Question 3c
; why am I getting an extra list layer here?
(define (unparse-prefix-exp exp)
  (cases prefix-exp exp
    (const-exp (num) (list num))
    (diff-exp (operand1 operand2)
              (list (append (unparse-prefix-exp operand1) '(-) (unparse-prefix-exp operand2)) ))
    )
  )

; Quesiton 3d
(define (eval-prefix-exp exp)
  (cases prefix-exp exp
    (const-exp (num) num)
    (diff-exp (operand1 operand2)
              (- (eval-prefix-exp operand1) (eval-prefix-exp operand2))
    )
  )
)