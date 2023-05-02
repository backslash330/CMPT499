#lang racket
; lab 3
; Status: Complete
(define bigBinaryTree '(a (large (unbalanced 1 2) 3) (binary 4 (tree 5 6))))


; Question 1
(define (leaf int)
  (cond
    [(not (integer? int)) (error "not an integer")]
    [else int]
  )
)

; Question 2
(define (leaf? t)
  (if (integer? t)
      #t
      #f)
)

; Question 3
;(define (interiorNode sym left right)
;  (list sym left right)
;)

; Question 4
(define (binTree? t)
  (or (integer? t)
      (and (pair? t)
           (= (length t) 3)
           (symbol? (car t))
           (binTree? (cadr t))
           (binTree? (caddr t)))))
; Question 5
(define (interiorNode sym left right)
    (cond
    [(not (symbol? sym)) (error "not an symbol")]
    [(not (binTree? left)) (error "not an symbol")]
    [(not (binTree? right)) (error "not an symbol")]
    [else (list sym left right)]
  )
)

; Question 6
(define  (lsof t)
  (cond
  [(not (binTree? t)) (error "argument t is not a binary Tree")]
  [(integer? t) (error "argument t is an leaf and not a node")]
  [ else (cadr t)]
  )
)

(define  (rsof t)
  (cond
  [(not (binTree? t)) (error "argument t is not a binary Tree")]
  [(integer? t) (error "argument t is an leaf and not a node")]
  [ else (caddr t)]
  )
)

(define  (contents-of t)
  (cond
  [(not (binTree? t)) (error "argument t is not a binary Tree")]
  [(integer? t) (error "argument t is an leaf and not a node")]
  [ else (list (cadr t) (caddr t))]
  )
)