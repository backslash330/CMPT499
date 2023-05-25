#lang racket
; Assignmnet 3
; Status Incomplete

; Question 1

; a

; By definition the representation for 1 is (one) and -1 is (diff (one)(diff (one) (one)))
; To represent 0 we would simply use (diff (one) (one))
; To represent 2 we would use (diff (one) (diff (one)(diff (one) (one)))) which is 1 - (-1) = 2
; to prove that there is a representation for any integer n where n > 2 prove that there is a representation for n+1
; for n+1 we can simply keep adding  (diff (one)(diff (one) (one))) to the end of the diff tree, thus effectively adding 1 to our representation
; to prove that there is a representaiton for any negative integer n where n < zero we simply add (diff (one)(diff (one) (one))) to the fron of our representation
; for example -2 would be (diff (diff (one)(diff (one) (one))) (one)).
; Therefore all integers have representations in this system.
; We can prove that there are infinite representations for any number by considering that 0 is represented by  (diff (one) (one)). We can arbitarly add as many 0 representation leafs
; as we want to the tree, which will give us infinitly many representaitons for the same number without changing the  number we are representing

; b
(define zero
  (lambda ()
    '(diff (one) (one))
  )
)

(define (is-zero? tree)
  (cond
    ; error checking
    [(not (list? tree)) (error "is-zero?: argument must be a list, but is " tree)]
    ((equal? tree '(diff (one) (one))) #t)
    (else #f)
  )
)

(define successor
  (lambda (n)
  (list 'diff n '(diff (diff (one) (one)) (one)))
  )
)

(define predecessor
  (lambda (n)
    (list 'diff n '(one))
  )
)

(define ->number
  (lambda n
      (if (eqv? (car n) 'one)
        1
        (- (->number (cadr n)) (->number (caddr n)))
      )
  )
)

;c
; This works because we effectively do (a - (0-b)) = (a - (-b) = (a+b)
(define diff-tree-plus
  (lambda (tree1 tree2)
    (list 'diff tree1 (list 'diff '(diff (one) (one)) tree2))))

; Question 2
;a)  See attached sheet
; b) See attached sheet
; c)
; I'm unsure why this one doesn't work. It follows the pattern of the textbook example but that doesn't work OOB either.
; Define the constructors

; empty-stack: () -> Stack
(define empty-stack
  (lambda ()
    (lambda (message)
      (cond
        ((eq? message 'pop) (error "Stack underflow - cannot pop from an empty stack"))
        ((eq? message 'peek) (error "Cannot peek an empty stack"))
        ((eq? message 'empty-stack?) #t)
        (else (error "Invalid stack operation"))))))


; push: Stack x Element -> Stack
(define push
  (lambda (stack element)
    (lambda (message)
      (cond
        ((eq? message 'pop) (stack))
        ((eq? message 'peek) (element))
        ((eq? message 'empty-stack?) #f)
        (else (error "Invalid stack operation"))))))

; Define the observers

; pop: Stack -> Stack
(define pop
  (lambda (stack)
    (stack 'pop)))

; peek: Stack -> Element
(define peek
  (lambda (stack)
    (stack 'peek)))

; empty-stack?: Stack -> Boolean
(define empty-stack?
  (lambda (stack)
    (stack 'empty-stack?)))

; Question 3
(define empty-env
(lambda ()
(lambda (search-var)
(report-no-binding-found search-var))))


(define extend-env
(lambda (saved-var saved-val saved-env)
(lambda (search-var)
(if (eqv? search-var saved-var)
saved-val
(apply-env saved-env search-var)))))

(define apply-env
(lambda (env search-var)
(env search-var)))

(define report-no-binding-found
(lambda (search-var)
(error "No binding for ~s" search-var)))

(define (empty-env? env)
  (eq? env empty-env)
)
