#lang racket
(require eopl)
; Assignment 4
; Status: Incomplete


; Question 1, see attached sheet.


; question 2

; example from class:
;;; 1(define (parse-expression datum )
;;; 2 (cond
;;; 3 ; Variable Expression (var-exp)
;;; 4 [ (symbol? datum)
;;; 5 (var-exp datum)]
;;; 6
;;; 7 ; Lambda Expression (lambda-exp)
;;; 8 [ (and (list? datum) (eqv? (car datum) 'lambda))
;;; 9 (lambda-exp
;;; 10 (caadr datum)
;;; 11 (parse-expression (caddr datum))) ]
;;; 12
;;; 13 ; App Expression (app-exp)
;;; 14 [ (list? datum)
;;; 15 (app-exp
;;; 16 (parse-expression (car datum))
;;; 17 (parse-expression (cadr datum)))]
;;; 18
;;; 19 ; Invaid Expression
;;; 20 [ else (raise-arguments-error
;;; 21 'parse-expression
;;; 22 "Invalid LcExp"
;;; 23 "LcExp" datum) ] ) )
;;; Modify parse-expression so that it is robust, accepting any s-expression
;;; and issuing an appropriate error message if the input does not represent
;;; a valid lambda-calculus expression. For full marks, your implementation
;;; must report the error and reference the original s-expression passed into
;;; your function. Again, assume the datatype lc-exp on page 46 of the
;;; textbook. Hint: Look into the (with-handlers ...) procedure
(define-datatype lc-exp lc-exp?
(var-exp
(var identifier?))
(lambda-exp
(bound-var identifier?)
(body lc-exp?))
(app-exp
(rator lc-exp?)
(rand lc-exp?)))


;;; (define (parse-expression datum)
;;; ; we want to make a lec rec or helper function 
;;; ; that does what we want and has 
;;; ; with handlers return expression

;;;   (with-handlers ([exn:fail? (lambda (exn)
;;;                                (raise-arguments-error
;;;                                 'parse-expression
;;;                                 "Invalid LcExp"
;;;                                 "LcExp" datum))])

;;;     ; call helper function with datum, with-handlers will catch issue 

;;;     ; this goes in a helper function with more robust error checking
;;;     (cond
;;;       [(symbol? datum) (var-exp datum)]
;;;       [(and (list? datum) (eqv? (car datum) 'lambda))
;;;        (lambda-exp (caadr datum)
;;;                    (parse-expression (caddr datum)))]
;;;       [(list? datum)
;;;        (app-exp (parse-expression (car datum))
;;;                 (parse-expression (cadr datum)))])))


(define (parse-expression datum)
  (with-handlers ([exn:fail? (lambda (exn)
                               (raise-arguments-error
                                'parse-expression
                                "Invalid LcExp"
                                "LcExp" datum))])
    (parse-expression-helper datum)
    )
  )

(define (parse-expression-helper datum)
  (cond
    [(symbol? datum) (var-exp datum)]
    ;;; [(and (list? datum) (eqv? (car datum) 'lambda))
    ;;;  (lambda-exp (caadr datum)
    ;;;              (parse-expression (caddr datum)))]
    ;;; [(list? datum)
    ;;;  (app-exp (parse-expression (car datum))
    ;;;           (parse-expression (cadr datum)))]))
    ; if the datum is a pair, then we need to check if it is a lambda or app as above
    ; otherwise it is an error
    [(pair? datum) (cond
                    [(eqv? (car datum) 'lambda) (lambda-exp (caadr datum)
                                                            (parse-expression-helper (caddr datum)))]
                    [else (app-exp (parse-expression (car datum))
                                           (parse-expression (cadr datum)))])
    ]
    [else (raise-arguments-error
           'parse-expression
           "Invalid LcExp"
           "LcExp" datum)]
    )
  )

; test cases
; (parse-expression 'x)
; (parse-expression '(lambda (x) x))
; (parse-expression '(lambda (x) (lambda (y) x)))



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