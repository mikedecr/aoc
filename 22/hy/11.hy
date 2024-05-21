(import pprint [pprint])
(import dataclasses [dataclass])
(import operator :as op)
(require hyrule [->])
(import toolz :as tt)
(setv file "data/11/test.txt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;    abstract things    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

; partial map
(defn mapping [f] (tt.curry map f))

; only: [a] -> a
(defn only [collection]
  (assert (= 1 (len collection)))
  (next (iter collection)))


;;;;;;;;;;;;;;;;;;
;;    tedium    ;;
;;;;;;;;;;;;;;;;;;

; read to a list of lines
(defn read_all [file]
  (with [o (open file "r" :newline "\n")]
    (-> o (.readlines)
          ((mapping (fn [l] (str.rstrip l "\n"))))
          (list))))

; clean list of lines to a list of tuples, each tuple a "monkey" recipe
(defn extract-monkeys [lst]
  (let [tups (list (tt.partitionby (fn [x] (= x "")) raw))]
    (list (filter (fn [t] (!= t #(""))) tups))))

(setv raw (read_all file))
(setv mks (extract-monkeys raw))
     
;;;;;;;;;;;;;;;
;;    lib    ;;
;;;;;;;;;;;;;;;

; ----- get the value data out of each thing ----------
; tuple -> string
(defn parse-field [monkey key]
  (let [element (only (list (filter (fn [l] (in key l)) monkey)))]
    (. element 
       (replace (+ key ":") "")
       (strip))))

;test   
(parse-field (tt.first mks) "Starting items")
(parse-field (tt.first mks) "If false")

; parse starting items to a list of ints
(defn parse-items [monkey]
  (let [val (parse-field monkey "Starting items")]
    (destring-ints val)))

(defn destring-ints [string]
  (let [str-ints (.split string ", ")]
    (list (map int str-ints))))

(defn parse-operation [monkey]
  (let [op-value (parse-field monkey "Operation")]
    (let [op-expr (.replace op-value "new = " "")]
      (let [op-split (.split op-expr " ")]
        (to-prefix (unpack-iterable op-split))))))

(defn to-prefix [a operation b]
  (let [funcmap {"+" op.add "-" op.sub "*" op.mul "/" op.truediv}]
    (let [func (get funcmap operation)]
      (fn [old]
        (let [args (list (map (fn [e] (if (= e "old") old (eval e))) [a b]))]
          (func (unpack-iterable args)))))))

(defn parse-test [monkey]
  (let [test-value (parse-field monkey "Test")]
    (let [divisor (eval (tt.last (.split test-value " ")))]
      (fn [x] 
        (op.eq 0 (% x divisor))))))

(defn parse-test-result [text field]
  (let [pass-field (parse-field text field)]
    (let [digits (list (filter str.isdigit pass-field))]
      (int (only digits)))))

(defn parse-pass [text] (parse-test-result text "If true"))
(defn parse-fail [text] (parse-test-result text "If false"))



; ----- monkey class ----------
; an immutable record type that holds monkey data
(setv function-type (type (fn [])))
;; (defclass [(dataclass :frozen True)] Monkey []) 
(defclass [dataclass] Monkey [] 
  #^ list items
  #^ function-type operation
  #^ function-type test
  #^ int passing
  #^ int failing)

(defn create-monkey [text]
  (let [funcs (tt.juxt parse-items parse-operation parse-test parse-pass parse-fail)]
    (let [vals (funcs text)]
      (Monkey (unpack-iterable vals)))))

(defn calc-tosses [m]
  (list (map (tt.curry calc-toss m) m.items)))

(defn calc-toss [m item]
  (-> item 
      (m.operation)
      (boredom-decay)
      ((handoff m))))

(defn boredom-decay [item]
  (// item 3))

(defn handoff [m]
  (fn [item] 
    (let [test-val (m.test item)]
      (if test-val #(m.passing item)
                   #(m.failing item)))))

; monkeys -> (monkeys, counts)
(defn monkey-round [monkeys]
  (setv counts [])
  (for [i (range (len monkeys))]
    (let [m (tt.nth i monkeys)]
      (setv counts (+ counts [len m.items]))
      (setv tosses (calc-tosses m))
      (setv m.items [])
      (setv monkeys (update-monkeys monkeys tosses))
      (print tosses)))
  #(monkeys counts))


(defn remove-items [monkey]
  (let [new (.copy monkey)]
    (setv new.items [])
    new))

(defn replace-element [collection index value]
  (let [col-type (type collection)]
    (lfor i (range (len collection))
      (if (= i index) value (tt.nth i collection))))) 
      
      

(defn update-monkeys [monkeys tosses]
  (for [#(ix, val) tosses]
    (print ix)
    (print val)))
  
          
;; ; (monkey, int) -> (int, int)
;; (defn monkey-item-routine [monkey item]
;;   (-> item 
;;       (enhance-worry monkey)
;;       (boredom-decay)
;;       (handoff monkey)))

;; ; collect all tosses for all items in monkey.items
;; ; monkey -> ([(int, int)])
;; (defn monkey-routine [monkey]
;;   (list (map (tt.curry monkey-item-routine monkey) monkey.items)))

;; (defn update-monkey [monkey item]
;;   (let [new-items (+ monkey.items [item])]
;;     (Monkey new-items
;;             monkey.operation
;;             monkey.test
;;             monkey.passing
;;             monkey.failing)))

        
(setv ma (Monkey [1 2]))

(.append ma.items 3)
ma.items


(dataclass :frozen True)
 

(Monkey [1 2])
  



