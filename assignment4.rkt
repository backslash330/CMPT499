#lang racket
(require eopl)
; Assignment 4
; Status: Incomplete


; Question 1, see attached sheet.


; question 2
; ask about why var-exp fails in the original code
; textbook example fails
;;; (define parse-expressiontextbook
;;; (lambda (datum)
;;; (cond
;;; ((symbol? datum) (var-exp datum))
;;; ((pair? datum)
;;; (if (eqv? (car datum) ’lambda)
;;; (lambda-exp
;;; (car (cadr datum))
;;; (parse-expression (caddr datum)))
;;; (app-exp
;;; (parse-expression (car datum))
;;; (parse-expression (cadr datum)))))
;;; (else (report-invalid-concrete-syntax datum)))))


;;; ; assignment example fails
;;; (define (parse-expression datum )
;;;  (cond
;;;  ; Variable Expression (var-exp)
;;;  [ (symbol? datum)
;;;  (var-exp datum)]

;;;  ; Lambda Expression (lambda-exp)
;;;  [ (and (list? datum) (eqv? (car datum) 'lambda))
;;;  (lambda-exp
;;;  (caadr datum)
;;;  (parse-expression (caddr datum))) ]

;;;  ; App Expression (app-exp)
;;;  [ (list? datum)
;;;  (app-exp
;;;  (parse-expression (car datum))
;;;  (parse-expression (cadr datum)))]

;;;  ; Invaid Expression
;;;  [ else (raise-arguments-error
;;;  'parse-expression
;;;  "Invalid LcExp"
;;;  "LcExp" datum) ] ) )

;(define (parse-expression2 datum)
; we want to make a lec rec or helper function 
; that does what we want and has 
; with handlers return expression

;  (with-handlers ([exn:fail? (lambda (exn)
;                               (raise-arguments-error
;                                'parse-expression
;                                "Invalid LcExp"
;                                "LcExp" datum))])

    ; call helper function with datum, with-handlers will catch issue 

    ; this goes in a helper function with more robust error checking

 ;   (cond
 ;     [(symbol? datum) (var-exp datum)]
 ;     [(and (list? datum) (eqv? (car datum) 'lambda))
 ;      (lambda-exp (caadr datum)
 ;                  (parse-expression (caddr datum)))]
 ;     [(list? datum)
 ;      (app-exp (parse-expression (car datum))
 ;               (parse-expression (cadr datum)))])))


;Question 3a
; see attached sheet

; Question 3b

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
  ;(car (parse-rec lst)))
  ; rewrite to have error checking
  (cond 
    ((null? lst) (raise-arguments-error 'parse-prefix-exp "Empty List" "List" lst))
    ((not (list? lst)) (raise-arguments-error 'parse-prefix-exp "Not a List" "List" lst))
    (else (car (parse-rec lst)))
  )
)
; Question 3c
; why am I getting an extra list layer here?
(define (unparse-prefix-exp exp)
  (cases prefix-exp exp
    (const-exp (num) num)
    (diff-exp (operand1 operand2)
              (list (unparse-prefix-exp operand1) '- (unparse-prefix-exp operand2)) )
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