#lang racket
; Lab 9
; Status: Complete

; Question 1
let f = proc (x)
-(x,-11)
in (f (f 77))


; Question 2
; This was accidently included in the repo
let makemult = proc (maker)
                        proc (x)
                            proc (y)
                              if zero?(x)
                              then 0
                              else -((((maker maker) -(x,1))  y), -(0,y) )
       in let times = proc (x) proc(y) (((makemult makemult) x) y)
          in 
          

         let makefactorial = proc (maker)
                                 proc (x)
                                   if zero?(x)
                                   then 1
                                   else ((times ((maker maker) -(x,1))) x)
                in let factorial = proc (x) ((makefactorial makefactorial) x)
                   in (factorial 5)
