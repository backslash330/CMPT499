;##########################################################
;#                                                        #
;# the nameless-PROC interpreter                          #
;# ====================================================== #
;# CMPT 340: Assignment 6                                 #
;# YOUR NAME                                              #
;# ID NUMBER                                              #
;##########################################################

#lang racket
(require rackunit)
(require "interpreter.rkt" "datatypes.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;; TESTS ;;;;;;;;;;;;;;;;;;;;;;;;;;

;; simple arithmetic
(check-equal? (run "11") (num-val 11) "positive-const")
(check-equal? (run "-33") (num-val -33) "negative-const")
(check-equal? (run "-(44,33)") (num-val 11) "simple-arith-1")

;; nested arithmetic
(check-equal? (run "-(-(44,33),22)") (num-val -11) "nested-arith-left")
(check-equal? (run "-(55, -(22,11))") (num-val 44) "nested-arith-right")

;; simple variables
(check-equal? (run "x") (num-val 10) "test-var-1")
(check-equal? (run "-(x,1)") (num-val 9) "test-var-2")
(check-equal? (run "-(1,x)") (num-val -9) "test-var-3")

;; simple unbound variables
(check-exn exn:fail? (lambda() (run "foo")) "test-unbound-var-1")
(check-exn exn:fail? (lambda() (run "-(x,foo)")) "test-unbound-var-2")

;; simple conditionals
(check-equal? (run "if zero?(0) then 3 else 4") (num-val 3) "if-true")
(check-equal? (run "if zero?(1) then 3 else 4") (num-val 4) "if-false")

;; test dynamic typechecking
(check-exn exn:fail? (lambda() (run "-(zero?(0),1)")) "no-bool-to-diff-1")
(check-exn exn:fail? (lambda() (run "-(1,zero?(0))")) "no-bool-to-diff-2")
(check-exn exn:fail? (lambda() (run "if 1 then 2 else 3")) "no-int-to-if")

;; make sure that the test and both arms get evaluated
;; properly. 
(check-equal? (run "if zero?(-(11,11)) then 3 else 4") (num-val 3) "if-eval-test-true")
(check-equal? (run "if zero?(-(11, 12)) then 3 else 4") (num-val 4) "if-eval-test-false")

;; and make sure the other arm doesn't get evaluated.
(check-equal? (run "if zero?(-(11, 11)) then 3 else 0") (num-val 3) "if-eval-test-true-2")
(check-equal? (run "if zero?(-(11,12)) then 0 else 4") (num-val 4) "if-eval-test-false-2")

;; simple let
(check-equal? (run "let x = 3 in x") (num-val 3) "simple-let-1 ")

;; make sure the body and rhs get evaluated
(check-equal? (run "let x = 3 in -(x,1)") (num-val 2) "eval-let-body")
(check-equal? (run "let x = -(4,1) in -(x,1)") (num-val 2) "eval-let-rhs")

;; check nested let and shadowing
(check-equal? (run "let x = 3 in let y = 4 in -(x,y)") (num-val -1) "simple-nested-let")
(check-equal? (run "let x = 3 in let x = 4 in x") (num-val 4) "check-shadowing-in-body")
(check-equal? (run "let x = 3 in let x = -(x,1) in x") (num-val 2) "check-shadowing-in-rhs")

(check-equal? (run "(proc(x) -(x,1)  30)") (num-val 29) "apply-proc-in-rator-pos" )
(check-equal? (run  "let f = proc (x) -(x,1) in (f 30)") (num-val 29) "apply-simple-proc")
(check-equal? (run "(proc(f)(f 30)  proc(x)-(x,1))") (num-val 29) "let-to-proc-1")

(check-equal? (run "((proc (x) proc (y) -(x,y)  5) 6)") (num-val -1) "nested-procs")
(check-equal? (run "let f = proc(x) proc (y) -(x,y) in ((f -(10,5)) 6)") (num-val -1) "nested-procs2")
      
(check-equal? (run "
let fix =  proc (f)
            let d = proc (x) proc (z) ((f (x x)) z)
            in proc (n) ((f (d d)) n)
in let
    t4m = proc (f) proc(x) if zero?(x) then 0 else -((f -(x,1)),-4)
in let times4 = (fix t4m)
   in (times4 3)") (num-val 12) "y-combinator-1" )
       