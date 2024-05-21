(import dataclasses [dataclass])
(import operator [add])
(import toolz [compose_left first second curry flip juxt])
(import functools [reduce])
(require hyrule [->])

(defn readlines [path]
  (with [o (open path "rt" :newline "\n")]
        (.readlines o)))

; each line in the raw data gets pre-processed
(defn clean_move [m]
  (-> m (.rstrip)
        (.split)
        ((fn [x] #((first x) (int (second x)))))))

; ----- domain ----------

(defclass [dataclass] Point []
  #^ int x
  #^ int y)

;;;;;;;;;;;;;;;;;;;;;;
;;    playground    ;;
;;;;;;;;;;;;;;;;;;;;;;

; make a choice about this
(setv raw (readlines "data/09/test.txt"))
(setv data (list (map (compose_left strip_newlines split_at_space snd_to_int) raw)))

raw
data

; outer fn gets an entire move
; single move takes a (head xy) (tail xy) (head_dir)
  ; if U/R/D/Y, adjust head
  ; if either head xy greater than 2 from tail, set tail xy to old head?

;; (defn part1 )

(defn calc_dx [move]
  (case (first move)
        "R" (second move)
        "L" (* -1 (second move))
        else 0))

(defn calc_dy [move]
  (case (first move)
        "U" (second move)
        "D" (* -1 (second move))
        else 0))

; construct a tuple of diffs
(defn calc_move [move]
  (setv fns (juxt calc_dx calc_dy))
  (fns move))

(defn next_head [pt move]
  (setv diff (calc_move move))
  (setv pair (zip pt diff))
  (tuple (map (curry reduce add) pair)))

(next_head #(0 0) (first data))

; main:
; next head
; next tail (new old tail)

(defn next_tail [new_head old_head tail]
  (setv dx (- (first new_head) (first tail)))
  (setv dy (- (second new_head) (second tail)))
  (if (or (= dx 2) (= dy 2))
      old_head
      tail))

(next_tail (calc_move (first data)) #(0 0) #(0 0))

(setv head #(0 0))
(setv tail #(0 0))

(for [m data] 
  (setv nhead (next_head head m))
  (setv ntail (next_tail nhead head tail))
  (setv head nhead)
  (setv tail ntail)
  (print tail))







