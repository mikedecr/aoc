(import toolz [first second merge interleave last])
(import operator [add sub mul truediv])
(import functools [cache])

(defn readlines [filepath]
  (with [f (open filepath "r")]
    (list (map (fn [x] (.rstrip x)) f))))

;; (defn pair_to_dict [pair]
;;   {(first pair) (second pair)})

(defn parse_op [op] 
  (match op
    "*" mul
    "/" truediv
    "+" add
    "-" sub))

(defn construct_monkey_dict [mks]
  (setv pairs (list (map (fn [s] (.split s ": ")) mks)))
  (setv fst (map first pairs))
  (setv snd (map second pairs))
  (dict (zip fst snd)))

(defn compute [monkey]
  (setv mapper (construct_monkey_dict data))
  (setv val (.split (.get mapper monkey) " "))
  ;; (print [monkey val])
  (if (= (len val) 1)
      (eval (first val))
      ((parse_op (second val))
       (compute (first val))
       ;; (cached_compute (first val))
       (compute (last val)))))
       ;; (cached_compute (last val)))))

(setv cached_compute (cache compute))

;;;;;;;;;;;;;;;;
;;    main    ;;
;;;;;;;;;;;;;;;;

;; (setv file "data/21/test.txt")
(setv file "data/21/final.txt")
(setv data (readlines file))

;; (.get (construct_monkey_dict data) "root")
;; (.get (construct_monkey_dict data) "ljgn")

(compute "root")

(construct_monkey_dict data)


(setv pairs (list (map (fn [s] (tuple (.split s ": "))) data)))
pairs


(setv snds (list (map second pairs)))



(defn split_space [s] (.split s " "))
(defn is_cmd [s] (> (len (split_space s)) 1))

(list (map split_space (filter is_cmd snds)))

(list (map is_cmd snds))

(list (map (fn [s] (.split s " ")) snds))


(setv cmds (list (map (fn [s] (pair_to_dict (.split s ": "))) data)))

(setv ex_p (second cmds))
(setv ex_v (.get ex "dbpl"))

ex_v

(.values cmds)

(setv all_digit (fn [x] (all (map (fn [c] (.isdigit c)) x))))

(all_digit? ex_v)


(.get ex "dbpl")

