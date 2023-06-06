#lang racket
; Assignment 2
; Status: Complete

; Question 1
; See attached file

; Question 2
;(a) Friday, 08-Feb-13 09:00:00 GMT]
;This is in rfc1123-date format.

;Derivation:
; date
; rfc1123-date
; weekday , SP date2 SP time SP GMT
; Friday , SP date2 SP time SP GMT
; Friday , SP DIGIT DIGIT - month - DIGIT DIGIT SP time SP GMT
; Friday , SP 0 8 - Feb - 1 3 SP time SP GMT
; Friday, SP 08-Feb-13 SP time SP GMT
; Friday, 08-Feb-13 09:00:00 GMT

;(b) Fri, 08 Feb 2013 09:00:00 GMT
; Classification: rfc1123-date

; Derivation:
; date
; rfc1123-date
; wkday , SP date1 SP time SP GMT
; Fri , SP date1 SP time SP GMT
; Fri , SP DIGIT DIGIT SP month SP DIGIT DIGIT DIGIT DIGIT SP time SP GMT
; Fri , SP 0 8 SP Feb SP 2 0 1 3 SP time SP GMT
; Fri, SP 08 SP Feb SP 2013 SP time SP GMT
; Fri, 08 Feb 2013 09:00:00 GMT

;(c) Fri Feb 8 09:00:00 2013
; Classification: asctime-date

; Derivation:
; date
; asctime-date
; wkday SP date3 SP time SP DIGIT DIGIT DIGIT DIGIT
; Fri SP date3 SP time SP DIGIT DIGIT DIGIT DIGIT
; Fri SP month SP DIGIT DIGIT SP time SP DIGIT DIGIT DIGIT DIGIT
; Fri SP Feb SP 8 SP time SP 2 0 1 3
; Fri SP Feb SP 8 SP time SP 2013
; Fri SP Feb SP 8 SP 09:00:00 SP 2013
; Fri Feb 8 09:00:00 2013

; Question 3
;Theorem: Let e be a LcExp as defined by definition 1.1.8

;Proof: This proof is by induction on the structure of e where e is an element of LcExp.

;Induction Hypothesis(IH): For any an element of LcExp they will always have the same number of left and right parentheses.

;Inductive proof: we must prove that e has a balanced number of left and right parenthese for the base case and we then prove that this holds true for all other elements of LcExp.

;Base Case: If e is an Identifier then there are no parentheses which means they are balanced.

;Based on Definition 1.1.8 there are a number of cases we need to look at to prove that our brackets hold for all elements of LcExp

;	1) The element can be in the form (lambda (Identifier) LcExp) then by definition the outer expression has the same number of left and right parentheses. We proved in the base case that an identifier has no parentheses, so we have matching there as well. Finally the subexpression LcExp will have balanced if it is an Idenfiter, as previously shown, or if it is in the form  (lambda (Identifier) LcExp) . We will also show that it will be balanced in the form (LcExp LcExp)
;	2) The element can be in the form (LcExp LcExp). This outer form has a balanced number of left and right parentheses. If the inner LcExp's must be in the base case, the form (lambda (Identifier) LcExp) or the form (LcExp LcExp). Since we have shown that each of these forms have a balanced number of parentheses then regardless of the combination of LcExp and LcExp that the element has the same number of left and right parentheses.

;Therefore we have shown that for every element of LcExp the number of left and right parentheses will be balanced. 


; Question 4
(define (product sos1 sos2)
  (cond
    [(not (list? sos1)) (error "product: first argument must be a list, but is " sos1)]
    [(not (list? sos2)) (error "product: second argument must be a list, but is " sos2)]
    [(or (null? sos1) (null? sos2)) '()]
    [else (apply append (map (lambda (x) (map (lambda (y) (list x y)) sos2)) sos1))]))


; Question 5
(define (sort pred loi)
  (cond
    ((not (procedure? pred)) (error "pred must be a procedure"))
    ((not (list? loi)) (error "loi must be a list"))
    ; if the list is null, then we return the empty list
    ((null? loi) '())
    ((null? (cdr loi)) loi)
    ; if the list is not null, then we check the first element of the list
    ; if the first element satisfies the predicate, then we return the first element and we call srt on the cdr of the list
    ; if the first element does not satisfy the predicate, then we call srt on the cdr of the list and we append the first element to the result
    ((pred (car loi) (car (cdr loi))) (append (list (car loi)) (sort pred (cdr loi))))
    (else (append (sort pred (cdr loi)) (list (car loi))))
  )
)
(define (srt pred loi)
  (cond
    ((not (procedure? pred)) (error "pred must be a procedure"))
    ((not (list? loi)) (error "loi must be a list"))
    ((null? loi) '())
    ((pred (car loi))
     (cons (car loi) (srt pred (cdr loi))))
    (else
     (cons (car loi) (srt pred (cdr loi))))))


; Question 6
(define (list-index pred lst)
  (define (list-index-helper pred lst index)
    (cond ((null? lst) #f) 
          ((pred (car lst)) index) 
          (else (list-index-helper pred (cdr lst) (+ index 1)))))
  
  (cond ((not (procedure? pred)) (error "pred must be a procedure"))
        ((not (list? lst)) (error "lst must be a list"))
        ((number? (list-index-helper pred lst 0)) (list-index-helper pred lst 0))
        (else #f)))


; Question 7
(define (path n bst)
  (cond
    ; error check to ensure the data is correct
    [(not (list? bst)) (error "second argument must be a list, but is " bst)]
    [(not (number? n)) (error "first argument must be a number, but is " n)]
    [(null? bst) (error "path: No path can be found to " n)]
    ; if the first element of the list is the number we are looking for, then we return the empty list
    [(= (car bst) n) '()]
    ; if the first element of the list is not the number we are looking for, then we check if the number is greater than or less than the first element
    [else (if (> (car bst) n) (cons 'left (path n (cadr bst))) (cons 'right (path n (caddr bst))))]
  )
)