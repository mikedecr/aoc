(import pprint [pprint])
(import numpy :as np)
(import toolz :as tt)
(import functools :as ft)
(import more_itertools [split_at])
(import operator :as op)
(require hyrule [->])

;; (setv mapping (fn [f] (tt.curry map f)))

(setv lmap (tt.compose list map))

(defn read_strip [filepath]
  (with [f (open file "r")]
       (let [lines (.readlines f)]
         (lmap (fn [x] (.rstrip x "\n")) lines))))

(defn eq [a [b None]]
  (if (is b None) (fn [b] (eq a b))
      (= a b)))

(defn separate_crates_and_moves [string]
  (let [pieces (tt.partitionby (fn [x] eq "" x) string)]
    (lmap list pieces)))

(separate_crates_and_moves raw)

    
  
(let [empty_tuple (fn [x] (= x #("")))
      empty (fn [x] (= x ""))]
  (let 3parts (list tt.partitionby)))
(let)
(setv empty (fn [x] (= x "")))
(setv 3parts (list (partitionby empty string)))
(tuple (map list (filterfalse empty_tuple 3parts)))
  
  

(setv file "data/05/test.txt")
(setv raw (read_strip file))


