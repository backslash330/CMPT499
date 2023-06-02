#!/usr/bin/env racket
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;        You do not need to modify this file            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#lang racket
(require  "interpreter.rkt" ; Load the interpreter
          "tests.rkt"  )    ; Load & run tests


(command-line
  #:program "LETREC"
  #:args filenames   ; expect any number of arguments [filename [filename [...]]]

  (if (null? filenames)

    ; Interactive Mode
    (with-handlers
      ( (string? (lambda(message) 
          (displayln message)
          (exit) )
      ) )
      (displayln "Welcome to LETREC v0.42")
      (displayln "Press <ctrl>+d to exit")
      (read-eval-print)
    )
    
    ; Interpret external program texts
    (for ((filename filenames))
      (with-handlers
        ; Exception Invalid Filename
        ( (exn:fail:filesystem? (lambda(exn)
            (printf "ERORR: Invalid File: ~a" filename)
            (exit) ) )
          ; Exception "Goodbye!" from Interpreter
          (string? (lambda(message)
            ; Terminate gracefully, closing the input file
            (unless (equal? message "Goodbye!") 
              (displayln (regexp-replace #px"^ERROR:" message ( ~a "ERROR [" filename "]:") ))
              (exit)
        ) ) ) )
        (with-input-from-file	 filename read-eval-print) ; evaluate the file
) ) ) )