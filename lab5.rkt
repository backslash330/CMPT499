#lang racket
; Lab 5
; Status: Complete
; Question 1
(define (empty-stack)
  '()
 )
(define (push val stack)
  (append stack (list val))
)
(define (pop stack)
  (reverse (cdr (reverse stack) ) )
)
(define (peek stack)
  (car (reverse stack))
)
(define (empty-stack? stack)
  (null? stack)
)
; Question 2
;;; (define (RPN-Eval rpnexp)
;;;   (define (eval-exp stack exp)
;;;     (cond
;;;       ((null? exp) (peek stack))
;;;       ((number? (car exp)) (eval-exp (push (car exp) stack) (cdr exp)))
;;;       ((eq? (car exp) '-)
;;;        (let ((a (peek stack))
;;;              (b (peek (pop stack))))
;;;          (eval-exp (push (- b a) (pop (pop stack))) (cdr exp))))
;;;       (else (error "Invalid token" (car exp)))))
;;;   (if (= (length rpnexp) 0)
;;;       (error "Empty expression")
;;;       (eval-exp '() rpnexp))
;;; )

; Question 3
;;; (define (RPN-Eval rpnexp)
;;;   (define (eval-exp stack exp)
;;;     (cond
;;;       ((null? exp) (peek stack))
;;;       ((number? (car exp)) (eval-exp (push (car exp) stack) (cdr exp)))
;;;       ((procedure? (eval (car exp)))
;;;        (let ((a (peek stack))
;;;              (b (peek (pop stack))))
;;;          (eval-exp (push ((eval (car exp)) b a) (pop (pop stack))) (cdr exp))))
;;;       (else (error "Invalid token" (car exp)))))
;;;   (if (= (length rpnexp) 0)
;;;       (error "Empty expression")
;;;       (eval-exp '() rpnexp))
;;; )

; Question 4
; need to use the mentioned prodecure to add another condition for unary expressins

(define (RPN-Eval rpnexp)
  (define (eval-exp stack exp)
    (cond
      ((null? exp) (peek stack))
      ((number? (car exp)) (eval-exp (push (car exp) stack) (cdr exp)))
      ((and (procedure? (eval (car exp)))
            (procedure-arity-includes? (eval (car exp)) 2))
       (let ((a (peek stack))
             (b (peek (pop stack))))
         (eval-exp (push ((eval (car exp)) b a) (pop (pop stack))) (cdr exp))))
      ; added unary operators
      ((and (procedure? (eval (car exp)))
            (procedure-arity-includes? (eval (car exp)) 1))
         (let ((a (peek stack)))
            (eval-exp (push ((eval (car exp)) a) (pop stack)) (cdr exp))))
     (else (error "Invalid token"))))
  (if (= (length rpnexp) 0)
      (error "Empty expression")
      (eval-exp '() rpnexp))
)


; Question 5
(define (factorial n)
  (if (= n 0)
      1
      (* n (factorial (- n 1)))))