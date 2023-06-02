;;; 1. See implementation of nameless prod in attached file

;;; 2. Consider the programming language EXPLICIT-REFS2
;;; . Write a rules of
;;; inference specification for each of the following:
;;; (a) [2 marks] zero? expression


;;; (b) [2 marks] call expression
;;; (c) [2 marks] A begin expression, where a begin expression is defined
;;; by the following grammar:
;;; Expression ::= begin Expression { ; Expression }
;;; ∗ end
;;; A begin expression may contain one or more subexpressions separated by semicolons. These are evaluated in order and the value of
;;; the last is returned.
;;; (d) [2 marks] list expression (defined in Assignment 5 Question 2e)




; Question 3

; Consider the following grammatical definition and rules of inference
;;; specification for setref expressions in EXPLICIT-REFS2
;;; 
;;; Expression ::= setref ( Expression , Expression )
;;; setref-exp (exp1 exp2)
;;; (value-of exp1 ρ σ0) = (⌈l⌉, σ1)
;;; (value-of exp2 ρ σ1) = (val, σ2)
;;; (value-of (setref-exp exp1 exp2) ρ σ0) = (⌈23⌉, [l = val] σ2)


;;; (a) [1 mark] Why does the specification return ⌈23⌉?

; The specification returns ⌈23⌉ as an arbitrary value.
; This is because the value of setref is not defined in the specification, it could be anything.
; The focus is not on the value that is returned, but the side effect of the setref expression. 


;;; (b) [2 marks] Modify the specification so that setref returns the value
;;; of the right-hand side of the expression.

; since the value of setref is not defined in the specification, it could be anything.
; therefore, we can change the specification to return the value of the right-hand side of the expression.

; Expression ::= setref ( Expression , Expression )
; setref-exp (exp1 exp2)
; (value-of exp1 ρ σ0) = (⌈l⌉, σ1)
; (value-of exp2 ρ σ1) = (val, σ2)
; (value-of (setref-exp exp1 exp2) ρ σ0) = (val, [l = val] σ2)



;;; (c) [2 marks] Modify the specification so that setref returns the oldcontents of the location.
; Expression ::= setref ( Expression , Expression )
; setref-exp (exp1 exp2)


; since the value of setref is not defined in the specification, it could be anything.
; therefore, we can change the specification to return the value of the right-hand side of the expression.

; (value-of exp1 ρ σ0) = (⌈l⌉, σ1)
; (value-of exp2 ρ σ1) = (val, σ2)
; (value-of (setref-exp exp1 exp2) ρ σ0) = (σ0(l), [l = val] σ2)
; OR IS THIS sigma1(l)????????


;;; (d) [1 mark] What does x = 5 return in C/C++?
; In C/C++, the expression x = 5 assigns the value 5 to the variable x 
;and also returns the assigned value, which is 5 in this case. 
;This means that x = 5 both sets the value of x to 5 and returns 5 as the result of the expression.




;;; (e) [1 mark] Provide an example of a C/C++ expression that returns
;;; the old-contents of a reference

; see attached cpp file. Essentiall we can increment x with x++
; this will return the old value of x and increment x by 1.
; when we print x, we will see the incremented value of x.