#lang racket
; Lab 4
; Status: Incomplete
; Question 1
(define N 10)
(define zero (list 0))
(define (is-zero? lst)
  (cond
  ((null? lst) #f)
  ((and (null? (cdr lst)) (zero? (car lst))) #t)
  (else #f) 
  )
)
(define (successor lst)
  (cond
    ((null? lst) (list 1))
    ((= (car lst) (- N 1)) (cons 0 (successor (cdr lst))))
    (else (cons (+ (car lst) 1) (cdr lst)))
  )
)
(define (predecessor lst)
  (cond
    ((is-zero? lst) zero)
    ((= (car lst) 0) (cons (- N 1) (predecessor (cdr lst))))
    (else (cons (- (car lst) 1) (cdr lst)))
  )
)
(define (->number lst)
  (cond
    ((is-zero? lst) 0)
    ((null? lst) 0)
    (else (+ (* (car lst) (expt N (- (length lst) 1))) (->number (cdr lst))))
  )
)

; question 2

;example
(define (plus x y)
  (if (is-zero? x)
      y
  (plus (predecessor x) (successor y))
  )
)

(define (multiply x y)
  (if (is-zero? x)
      zero
      (plus y (multiply (predecessor x) y))
  )
)