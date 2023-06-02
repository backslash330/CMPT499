;##########################################################
;#                                                        #
;# the nameless-PROC interpreter                          #
;# ====================================================== #
;# CMPT 340: Assignment 6                                 #
;# YOUR NAME                                              #
;# ID NUMBER                                              #
;##########################################################

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;        You do not need to modify this file            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#lang racket
(require  rackunit)

(provide make-readline-repl)

(define (make-readline-repl prompt-string eval-function stream-parser)

  (when (and (terminal-port? (current-input-port)) (regexp-match? #rx"xterm" (~s (getenv "TERM"))))
    (dynamic-require 'readline #f)
  )

  (letrec (
    (readlineEnabled  (module-declared? 'readline) )
    (interactive (or readlineEnabled (terminal-port? (current-input-port))))
    (prompt (lambda()
      (if readlineEnabled 
        ((dynamic-require/expose 'readline/pread 'readline-prompt) (string->bytes/locale prompt-string))
        (when interactive (display prompt-string) )
      )
      (when (checkEOF) (raise "Goodbye!") )
    ) )
    (read-eval-print (lambda()
      (with-handlers
        ( (exn:fail? (lambda(exn)
            (let ((message (~a "ERROR:" (regexp-replace #px"^[^\\s:]*:" (exn-message exn) "" ))))
              (if interactive
                (displayln message)
                (raise message)
            ) )
            (read-eval-print) ) )
          (string? (lambda(message) 
            (raise message)
            (exit) )) )

          ( (make-rep-loop prompt
            (lambda(exp) (eval-function exp) )
            stream-parser ) )
    ) ) ) )  
    (read-eval-print)
) )

(define sllgen:stdin-char-stream (dynamic-require/expose 'eopl/private/sllgen 'sllgen:stdin-char-stream))
(define sllgen:stream-get!       (dynamic-require/expose 'eopl/private/sllgen 'sllgen:stream-get!)) 
(define sllgen:stream->list (dynamic-require/expose 'eopl/private/sllgen 'sllgen:stream->list))


; DO NOT MODIFY
(define make-rep-loop
  (lambda (prompt eval-fn stream-parser)
    (lambda ()
      (if (procedure? prompt) (prompt) (display prompt)) (flush-output)      
      (let loop ((ast-stream (stream-parser (sllgen:stdin-char-stream))))
        (sllgen:stream-get! 
          ast-stream
          (lambda (tree stream)
            (printf "~a" (eval-fn tree))
            (newline)
            (if (procedure? prompt) (prompt) (display prompt))
            (flush-output)
            (loop stream)
          )
          (lambda () #f )
        )
      )
) ) )

;;; () -> Bool
; Checks for EOF ( <ctrl>+d )
;;;  DO NOT MODIFY
(define (checkEOF)
  (flush-output)
  (letrec 
    ((checkEOF (lambda(n)
      (let ((char (peek-char (current-input-port) n)))
        (or (eof-object? char )
            (and (char-whitespace? char ) (checkEOF (+ n 1)) )
    )))))
    (checkEOF 0)
) )  