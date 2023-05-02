; Lab 2
; Status: Complete
#lang racket

; Question 1
(define (lngth lst)
  (cond
    [(not (list? lst)) (error "not a list")]
    ((null? lst) 0)

    (else (+ 1 (lngth (cdr lst))))
  )
)

; Question 2
;(DeepAtomCount '(A B C) )
; (DeepAtomCount '() )
; (DeepAtomCount '(()) )
; (DeepAtomCount '((A) (B)) )
; (DeepAtomCount '(A (B C (D E) (F)) ((G H) (I))) )
; (DeepAtomCount 'A )
(define (DeepAtomCount lst)
  (cond
    [(not (list? lst)) (error "not a list")]
    [(null? lst) 0] 
    [(not (pair? lst)) 1]
    [(not (list? (car lst))) (+ 1  (DeepAtomCount (cdr lst)))] 
    [else 
      (+ (DeepAtomCount (car lst)) (DeepAtomCount (cdr lst)))) 
    )
  )

; Question 3
; need to fix
(define (in? atm lst)
  (cond
    ; check to ensure the data is correct 
    [(not (list? lst)) (error "in?: second argument must be a list, but is " lst)]
    [(list? atm) (error "in?: first argument must be an atom, but is " atm)]
    [(null? lst) #f] 
    [(equal? atm (car lst)) #t] 
    [(list? (car lst)) 
      (or (in? atm (car lst)) (in? atm (cdr lst)))]
    [else (in? atm (cdr lst))] 
  )
)
