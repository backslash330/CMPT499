#lang racket
; Assignmnet 3
; Status Complete

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

; convert ->number to zero = 0 then return true
(define (is-zero? tree)
  (cond
    ; error checking
    [(not (list? tree)) (error "is-zero?: argument must be a list, but is " tree)]
    ((equal? (->number tree) 0) #t)
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
  ; If the n is not in brackets, the file will compile but will give CADR error
  ; I am unsure why this is
  (lambda (n)
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
        ((eq? message 'pop) stack)
        ((eq? message 'peek) element)
        ((eq? message 'empty-stack?) #f)
        (else (error "Invalid stack operation"))))))

; Define the observers

; pop: Stack -> Stack(
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
    (list (lambda (search-var)
            (report-no-binding-found search-var))
          (lambda ()
            #t)
          (lambda (search-var)
            #f))))
; the second 


(define extend-env
(lambda (saved-var saved-val saved-env)
  ; this needs to be a list or preds will fail!
(list (lambda (search-var)
(if (eqv? search-var saved-var)
saved-val
(apply-env saved-env search-var)))
(lambda ()  #f)
(lambda (search-var)
(if (eqv? search-var saved-var)
#t
(has-binding? saved-env search-var))

            
            
            )
)))

(define apply-env
 ; car env search-var!
(lambda (env search-var)
((car env) search-var)))

(define report-no-binding-found
(lambda (search-var)
(error "No binding for ~s" search-var)))


(define (empty-env? env)
   ((cadr env))
)


;question 3b
; implement has-binding?
(define has-binding?
  (lambda (env search-var)
  ((caddr env) search-var)
))


; test cases for has-binding?
(define env1 (extend-env 'x 1 (empty-env)))
(define env2 (extend-env 'y 2 env1))
(define env3 (extend-env 'z 3 env2))

(has-binding? env3 'x) ; should return #t
(has-binding? env3 'y) ; should return #t
(has-binding? env3 'z) ; should return #t
(has-binding? env3 'a) ; should return #f


;question 3c
;;; Extend the environment interface to include the constructor
;;; extend-env*. This constructor takes a list of variables, a list of values
;;; of the same length, and an environment, and is specified by:
;;; (extend-env* ( var0...vark ) ( var0...valk ) ⌈F ⌉ ) = ⌈G⌉,
;;; where G(var) = 
;;; vali var = vari
;;; for 0 ≤ i ≤ k
;;; F(var) otherwise
;;; Extend your representation from (b) to include extend-env*. Your
;;; implementation of must run in constant time, i.e. extend-env* ∈
;;; O(1). Do so by defining a new constructor and representing the
;;; environment as a list of three procedures.

(define extend-env*
  (lambda (vars vals env)
  (if (null? vars)
  ; if vars is empty, return env
  env
  (extend-env* (cdr vars) (cdr vals) (extend-env (car vars) (car vals) env))
  )
))

; test cases for extend-env*
(define env4 (extend-env* '(x y z) '(1 2 3) (empty-env)))
(define env5 (extend-env* '(a b c) '(4 5 6) env1))
(define env6 (extend-env* '(d e f) '(7 8 9) env2))

(apply-env env4 'x) ; should return 1
(apply-env env4 'y) ; should return 2
(apply-env env4 'z) ; should return 3
(apply-env env5 'a) ; should return 4
(apply-env env5 'b) ; should return 5
(apply-env env5 'c) ; should return 6