(import pprint [pprint])
(import numpy [array cumsum])
(import toolz [partitionby
               curry
               first
               interleave
               compose
               tail
               take
               drop
               cons])
(import itertools [filterfalse])
(import more_itertools [split_at])
(require hyrule [->])

; each line has a pair (tuple) of ranges
; read to a list of such lines
(defn custom_rstrip [s] (.rstrip s "\n"))
(defn readlines [filepath]
  (with [f (open filepath "r")] (list (map custom_rstrip f))))

; turn readlines output into a tuple of [crate data], [move data]
(defn crates_and_moves [s]
  (setv empty (fn [x] (= x "")))
  (setv empty_tuple (fn [x] (= x #(""))))
  (setv 3parts (list (partitionby empty s)))
  (tuple (map list (filterfalse empty_tuple 3parts)))
  )

; string to dict of {move: x, from: y, to: z}
(defn clean_move [move]
  (setv data (tuple (.split move " ")))
  (setv isnum (fn [x] (.isdigit x)))
  (tuple (map int (filter isnum data))))

; this isn't working bc some chars have keys between Z and a
(defn is_letter [c]
  (setv uppers 
    (range (ord "A") (+ 1 (ord "Z"))))
  (setv lowers
    (range (ord "a") (+ 1 (ord "z"))))
  (setv k (ord c))
  (or (in k uppers) (in k lowers)))

(defn clean_crates [crates]
  ; transposes string lists data so each column "leads" with the column number.
  ; returns one-D generator
  (setv ordered 
        (-> crates ((curry map list))        ; strings to single chars
                   ((compose reversed list)) ; can't reverse a map
                   (interleave)))            ; has the effect of transposing the indices
  ; cut list by changing values of is_letter
  ; has the effect of grouping where adjacent letters appear (columns of crates)
  (setv grouped (list (partitionby is_letter ordered)))
  ; return only lists containing letters
  (setv blocks_only (filter (fn [g] (any (map is_letter g))) grouped))
  ; reverse order so we take from head == top
  (list (map list blocks_only)))

(defn correct_indices [move]
  (setv hd (first move))
  (setv rest (drop 1 move))
  (setv decr (map (fn [e] (- e 1)) rest))
  (tuple (cons hd decr)))



(setv file "data/05/test.txt")
(setv raw (readlines file))
(setv [crate_raw move_raw] (crates_and_moves raw))
(setv moves (list (map clean_move move_raw)))
(setv blocks (clean_crates crate_raw))
moves
blocks

(defn move_blocks [blocks mv]
  (setv #(move from to) (correct_indices mv))
  (setv ret (.copy blocks))
  (setv lifted (take move (nth from blocks)))
  (.append (nth to ret) (unpack-iterable (reversed (list lifted))))
  ret
  )
(tuple (move_blocks blocks (first moves)))

moves

list-of-moves

(take )

crate_raw
move_raw



(pprint raw)

  (setv lines (with [f (open filepath "r")] (list (map rstrip f))))
  (setv clean (compose_left (curry split_at ",")
                            (curry map parse_range)
                            tuple))
  (list (map clean lines)))

