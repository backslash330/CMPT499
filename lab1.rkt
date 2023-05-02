; lab 1
; Status: Complete
#lang racket 
; remeber to call in brackets (Fahrenheit->Celsius 0)
 (require htdp/convert)
; question 1
; call (convert-gui Fahrenheit->Celsius)
(define (Fahrenheit->Celsius FahrenheitTemp)
  (/ (- FahrenheitTemp 32) 1.8)
)

; question 2
;(convert-repl (lambda (FahrenheitTemp) (/ (- FahrenheitTemp 32) 1.8)))

; question 3
; call (convert-repl Fahrenheit->CelsiusLam)
(define f->c
  (lambda (FahrenheitTemp) (/ (- FahrenheitTemp 32) 1.8))
)


; question 4
(define (freezing? FahrenheitTemp)
  (<= (Fahrenheit->Celsius FahrenheitTemp) 0)
)
  