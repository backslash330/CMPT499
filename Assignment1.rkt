#lang racket
; Assignment 1
; Status: Incomplete


; Question 1
; R-> R
;  f(x) = x^3
; R -> Z
;  f(X) = ⌊x⌋
; R-> N:
;   f(x) = ⌊|x|⌋
; N × Z -> Q
;  f(n, z) = n/z

; Question 2
; Functional forms, also known as higher-order functions, are functions that can take a function as a paramter and can return a function.
; This is done with lambda expressions in lambda calculus.

; Referential Tranparency means that an execution of a function will not produce any side effects.
; This means that when a value is passed in we would expect to always get the same result with nothing else happening we aren't aware of.
; This means that the logic of a referential tranparent language should be clearly then one that is not (like an imperative language)


; Question 3

;(a) int FunctionA(int x) { return x*x; }
; This function is referentially transparent because there are no hidden side effects.
; The function takes in the integer x and multiples it with itself.
; Therefore the returned value will always be the same and nothing changes.

;(b) int FunctionB(int &x) { return abs(x); }
; This function is not referntially transparent.
; This is because the function uses a reference to x and is therefore dependent on x's current value
; calling this function at different steps of the program can result in different results.


;(c) int FunctionC(int &x, int &y) { return x = y = 42; }
; This function is not referentially transparent.
; Again this is because the function uses a reference to x and y.
; This program is actually worse as it's result assigns a value to both x and y which means this function will almost always have a side effect.
; (unless x and y are already 42)

;(d) int *FunctionD(int &x) { return &x; }
; This funciton is not referntially transparent.
; This is because the function takes a pointer and returns a pointer to that input.
; This means that if the memory address of x changes within the program, then two different call with the same variable can produce different results


; Question 4
; The first way we can use define is to bind a symbol to an expression
; While this may sound like variables it is differnt in that a DEFINE symbol is constant and does not change in the course of the program
; (DEFINE symbol expression)
;(DEFINE pi 3.14)

; The second way to use define is to bind a name to a lambda expression
; The typical way to do this is to abbreviate and remove the lambda keyword as seen below
; this is analagous to creating a funciton in an imperative language.

; (DEFINE ( function name parameters)
; body
; )
;(DEFINE (square number) (* number number))

; Question 5
; (a)
; see related pdf

; (b)
;
(define (Question-5b)
(cons 'A
      (cons (cons 'B
                  (cons 'C
                        (cons (cons 'D
                                    (cons 'E '()))
                              (cons (cons 'F '())
                                    '()))))
            (cons (cons (cons 'G
                              (cons 'H '()))
                        '())
                  (cons (cons 'I '())
                        '())))
)
)

; Question 6

(define (Question-6 lst)
  (if (null? lst)
      '()
      (append (Question-6 (cdr lst)) (list (car lst)))))
(define (Question-6b lst)
  (reverse lst))
; Question 7

(define (Question-7 lst1 lst2)
  (cond
  [(not (list? lst1)) (error "first argument must be a list, but is " lst1)]
  [(not (list? lst2)) (error "second argument must be a list, but is " lst2)]
    ; if both lists are empty, then they are structurally equal
  [(and (null? lst1) (null? lst2)) #t]
    ; if one list is empty and the other is not, then they are not structurally equal
  [(or (null? lst1) (null? lst2)) #f]
    ; if both lists are not empty, then we check  the first elemets of both lists
    ; if the elements are both symbols then they are equal
    ; if the elements are both lists, then we recursively call Question-7 on the elements 
    ; and we always call Question-7 on the cdr of both lists
  [(and (symbol? (car lst1)) (symbol? (car lst2))) (Question-7 (cdr lst1) (cdr lst2))]
  [(and (list? (car lst1)) (list? (car lst2))) (Question-7 (car lst1) (car lst2)) (Question-7 (cdr lst1) (cdr lst2))]
    ; if the elements are not equal, then the lists are not structurally equal
  [else #f]
  )
)

; Question 8
(define (Question-8 atm lst)
  (cond
    ; check to ensure the data is correct 
    [(not (list? lst)) (error "in?: second argument must be a list, but is " lst)]
    [(list? atm) (error "in?: first argument must be an atom, but is " atm)]
    ; if the list is null, then we return the empty list
    [(null? lst) '()]
    ; if the list is not null, then we check the first element of the list
    ; if the first element is a list, then we recursively call Question-8 on the first element
    ; and we always call Question-8 on the cdr of the list
    [(list? (car lst)) (cons (Question-8 atm (car lst)) (Question-8 atm (cdr lst)))]
    ; if the first element is not a list, then we check if the first element is equal to the atom
    ; if the first element is equal to the atom, then we return the cdr of the list
    ; if the first element is not equal to the atom, then we return the first element and we call Question-8 on the cdr of the list
    [(equal? (car lst) atm) (Question-8 atm (cdr lst))]
    [else (cons (car lst) (Question-8 atm (cdr lst))) ]
  )
)