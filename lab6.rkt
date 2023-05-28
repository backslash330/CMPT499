#lang racket
; Lab 6
; Status: Complete
; Question 1
;(require (lib "eopl.ss" "eopl"))
(require eopl)
(define-datatype bintree bintree?
  (leaf-node
   (num integer?))
  (interior-node
   (key symbol?)
   (left bintree?)
   (right bintree?)))



(define (binary-tree-to-list binary-tree)
    (cases bintree binary-tree
        (leaf-node (num) (list 'leaf-node num))
        (interior-node (key left right)
                     (list 'interior-node key (binary-tree-to-list left) (binary-tree-to-list right)))))

; Question 2
; the constructors are empty env and extend env
(define-datatype environment environment?
  (empty-env)
  (extend-env
   (var symbol?)
   (val integer?)
   (env environment?)))

(define (has-binding? env var)
  (cases environment env
    (empty-env () #f)
    (extend-env (var0 val env0)
                (if (symbol=? var var0)
                    #t
                    (has-binding? env0 var)))))

(define (empty-env? env)
  (cases environment env
    (empty-env () #t)
    (extend-env (var0 val env0) #f)))

(define (apply-env env var)
  (cases environment env
    (empty-env () (error "no binding for var"))
    (extend-env (var0 val env0)
                (if (symbol=? var var0)
                    val
                    (apply-env env0 var)))))
