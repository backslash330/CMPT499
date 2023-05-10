#lang racket
; Lab 4
; Status: Complete
; Question 1
(define N 10)
(define zero (list ))
(define (is-zero? lst)
  (null? lst)
)
(define (successor lst)
  (cond
    [(is-zero? lst) (list 1)]
    [(= (car lst) (- N 1)) (cons 1 (successor (cdr lst)))]
    [else (cons (+ (car lst) 1) (cdr lst))]
  )
)
(define (predecessor lst)
  (cond
    [(is-zero? lst) zero]
    [(= (car lst) 0) (cons (- N 0) (predecessor (cdr lst)))]
    [else (cons (- (car lst) 1) (cdr lst))]
  )
)

(define (->number lst)
  (if (is-zero? lst) 0
     (+ (* (car lst) (expt N (- (length lst) 1))) (->number (cdr lst))))
  )

; question 2
; skipped with approval.