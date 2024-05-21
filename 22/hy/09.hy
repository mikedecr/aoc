(require hyrule [->])
(import toolz :as tt)

(defn read-to-list [file]
  (with [o (open file "r" :newline "\n")]
    (let [dirty-lines (.readlines o)]
      (list (map clean-element dirty-lines)))))

(defn clean-element [elem]
  (let [spl (. elem (rstrip) (split " "))]
    (let [snd (int (tt.last spl))]
      #((tt.first spl) snd))))
                   

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;    testing ground    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

(setv file "data/09/test.txt")
(setv raw (read-to-list file))

(defn to-dydx [move]
  (lfor i (range (tt.last move)) (calc-unit (tt.first move))))

(defn move-head [hd move]
  (let [diffs (to-dydx move)]
    (list (scan hd add-pt diffs))))

; yooooooo
(defn scan [state fun iter]
  (for [i iter]
    (setv state (fun state i))
    (yield state)))

(list (scan #(0 0) add-pt (to-dydx (tt.first raw))))

(defn add-pt [a b]
  (tuple (gfor #(x y) (zip a b) (+ x y))))

(defn move-tail [tail new old]
  (if (gapped? new tail) old tail))
  


(defn execute-motion [head tail direction magnitude]
  (setv tails #{})
  (for [n (range magnitude)]
    (print n)
    (set.union tails #{tail}))
  tails)


(defn vague-execute [state move])
  

      

(defn rec-execute-motion [state direction magnitude]
    (if (= magnitude 0) 
      state
      (let [new-state (single-move (tt.first state) (tt.last state) direction)]
        (execute-motion new-state direction (- magnitude 1)))))

(defn memoize-tails [f]
  (setv tails {})
  (fn [state direction magnitude]
    (.union tails (tt.last state))
    (execute-motion state direction magnitude)))

(defn multi-move [hd tl move]
  (setv [direction n] (parse-move move))
  (let [steps (reversed (range 1 (+ n 1)))]
    (lfor i steps (single-move))))

; move hd and tl some direction
(defn single-move [hd tl direction]
  (let [new-hd (move hd direction 1)]
    (if (gapped? new-hd tl)
      (return #(new-hd hd))
      (return #(new-hd tl)))))

(defn gapped? [hd tl]
  (let [diffs (lfor #(a b) (zip hd tl) (abs (- a b)))]
    (any (map (fn [x] (>= x 2)) diffs))))

; move a pt n units in some direction
; calculate a scaled unit change and then add it to each dim in pt
(defn move [pt direction n]
  (let [unit (calc-unit direction)]
    (let [diffs (tuple (map (fn [d] (* n d)) unit))]
      (let [els (zip pt diffs)]
        (tuple (map sum els))))))

; calculate a unit vector given some direction
(defn calc-unit [direction]
  (let [mapping {"R" #(1 0)
                 "L" #(-1 0)
                 "U" #(0 1)
                 "D" #(0 -1)}]
    (.get mapping direction)))

(move #(0 0) "D" 3)

  

(defn do-round [hd tl direction number]
  (let [new-hd (+ hd direction 1)]
    (if (gapped? new-hd tl)))
  (return #(hd tl)))





  

