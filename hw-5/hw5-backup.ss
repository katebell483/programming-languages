(define (add-to-end lst e) 
   (if (null? lst) 
       (list e)
       (cons (car lst)
             (add-to-end (cdr lst) e))))

(define (member-check e lst)
  (cond
    [(not(pair? lst)) (eq? e lst)]
    [(eq? (car lst) e) #t]
    [else (member-check e (cdr lst))]))

; what happens if listdiff isn't listdiff?
(define (listdiff->list listdiff)
  (define (iter s1 s2 acc)
    (cond
      [(not(pair? s1)) (if (member-check s1 s2) acc (add-to-end acc s1))]
      [(member-check (car s1) s2) (iter (cdr s1) (cdr s2) acc)]
      [else (iter (cdr s1) s2 (add-to-end acc (car s1)))]))
  (iter (car listdiff) (cdr listdiff) empty))

(define (list->listdiff list)
  (cons list empty))
     
(define (null-ld? obj)
  (if (and (pair? obj) (eq? (car obj) (cdr obj))) #t #f)) 

(define (listdiff? obj)
  (define (iter x y)
    (cond
      [(eq? x y) #t]
      [(not(pair? y)) #f]
      [else (iter x (cdr y))]))
  (if (not(pair? obj)) #f (iter (cdr obj) (car obj))))

(define (cons-ld obj listdiff) (cons (cons obj (car listdiff)) (cdr listdiff)))

(define (car-ld listdiff) (car (listdiff->list listdiff)))
(define (cdr-ld listdiff) (list->listdiff (cdr (listdiff->list listdiff))))

(define (listdiff obj . args)
  (list->listdiff (cons obj args)))

; should only work on listdiffs
(define (length-ld listdiff) (length (listdiff->list listdiff)))

(define (assq-ld obj alistdiff)
  (define (iter lst)
  (cond
    [(empty? lst) #f]
    [(eq? (car (car lst)) obj) (car lst)]
    [else (iter (cdr lst))]
    ))
   (iter (listdiff->list alistdiff))
  )

(define (append-ld listdiff . args)
  (define (iter lst acc)
    (cond
      [(= (length lst) 1) (cons (append acc (listdiff->list (car lst))) (cdr lst))]
      [else (iter (cdr lst) (append acc (listdiff->list (car lst))))]))
 (iter (append (list listdiff) args) empty))

(define (expr-returning listdiff)
  (quasiquote (cons (quote (unquote (listdiff->list listdiff))) '())))
