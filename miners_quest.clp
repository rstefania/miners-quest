; ------------------------------
; DEFINIRE SABLON
; ------------------------------

(deftemplate instanta-selectata
   (slot id))

(deftemplate are-pozitia
   (slot entitate)
   (slot id)
   (slot linie)
   (slot coloana))

(deftemplate vecin
   (slot de)
   (slot la))

; ------------------------------
; INSTANTA 1
; ------------------------------
(defrule instanta-1
   (instanta-selectata (id ?id&1))
   =>
   (printout t "Am primit instanta: " ?id crlf)
   (assert (are-pozitia (entitate miner)    (linie 1) (coloana 1)))
   (assert (are-pozitia (entitate comoara)  (linie 8) (coloana 8)))
)

; ------------------------------
; INSTANTA 2
; ------------------------------
(defrule instanta-2
   (instanta-selectata (id ?id&2))
   =>
   (printout t "Am primit instanta: " ?id crlf)
   (assert (are-pozitia (entitate miner)   (linie 1) (coloana 1)))
   (assert (are-pozitia (entitate comoara) (linie 8) (coloana 8)))
   (assert (are-pozitia (entitate caramida) (id c1) (linie 2) (coloana 2)))
   (assert (are-pozitia (entitate caramida) (id c2) (linie 3) (coloana 4)))
   (assert (are-pozitia (entitate caramida) (id c3) (linie 4) (coloana 6)))
   (assert (are-pozitia (entitate caramida) (id c4) (linie 5) (coloana 5)))
   (assert (are-pozitia (entitate caramida) (id c5) (linie 6) (coloana 3)))
   (assert (are-pozitia (entitate caramida) (id c6) (linie 6) (coloana 7)))
   (assert (are-pozitia (entitate caramida) (id c7) (linie 7) (coloana 6)))
   (assert (are-pozitia (entitate caramida) (id c8) (linie 7) (coloana 2)))
   (assert (are-pozitia (entitate caramida) (id c9) (linie 2) (coloana 1)))
   (assert (are-pozitia (entitate caramida) (id c9) (linie 1) (coloana 4)))
)

; ------------------------------
; INSTANTA 3
; ------------------------------
(defrule instanta-3
   (instanta-selectata (id ?id&3))
   =>
   (printout t "Am primit instanta: " ?id crlf)
   (assert (are-pozitia (entitate miner)   (linie 1) (coloana 1)))
   (assert (are-pozitia (entitate comoara) (linie 4) (coloana 4)))
   (assert (are-pozitia (entitate caramida) (id b1) (linie 3) (coloana 4)))
   (assert (are-pozitia (entitate caramida) (id b2) (linie 5) (coloana 4)))
   (assert (are-pozitia (entitate caramida) (id b3) (linie 4) (coloana 3)))
   (assert (are-pozitia (entitate caramida) (id b4) (linie 4) (coloana 5)))
   (assert (are-pozitia (entitate caramida) (id b5) (linie 3) (coloana 3)))
   (assert (are-pozitia (entitate caramida) (id b6) (linie 3) (coloana 5)))
   (assert (are-pozitia (entitate caramida) (id b7) (linie 5) (coloana 3)))
   (assert (are-pozitia (entitate caramida) (id b8) (linie 5) (coloana 5)))
)


; ------------------------------
; REGULI DE DEPLASARE MINER
; ------------------------------

(defrule muta-miner-stanga
   ?m <- (are-pozitia (entitate miner) (linie ?l) (coloana ?c))
   (are-pozitia (entitate comoara) (linie ?lt) (coloana ?ct))
   (test (> ?c ?ct))
   =>
   (bind ?cn (- ?c 1))
   (if (not (any-factp ((?f are-pozitia))
            (and (eq (fact-slot-value ?f entitate) caramida)
                 (eq (fact-slot-value ?f linie) ?l)
                 (eq (fact-slot-value ?f coloana) ?cn))))
   then
      (retract ?m)
      (assert (are-pozitia (entitate miner) (linie ?l) (coloana ?cn)))
      (printout t "Minerul mutat la stanga: (" ?l "," ?cn ")" crlf)
   )
)

(defrule muta-miner-dreapta
   ?m <- (are-pozitia (entitate miner) (linie ?l) (coloana ?c))
   (are-pozitia (entitate comoara) (linie ?lt) (coloana ?ct))
   (test (< ?c ?ct))
   =>
   (bind ?cn (+ ?c 1))
   (if (not (any-factp ((?f are-pozitia))
            (and (eq (fact-slot-value ?f entitate) caramida)
                 (eq (fact-slot-value ?f linie) ?l)
                 (eq (fact-slot-value ?f coloana) ?cn))))
   then
      (retract ?m)
      (assert (are-pozitia (entitate miner) (linie ?l) (coloana ?cn)))
      (printout t "Minerul mutat la dreapta: (" ?l "," ?cn ")" crlf)
   )
)

(defrule muta-miner-sus
   ?m <- (are-pozitia (entitate miner) (linie ?l) (coloana ?c))
   (are-pozitia (entitate comoara) (linie ?lt) (coloana ?ct))
   (test (> ?l ?lt))
   =>
   (bind ?ln (- ?l 1))
   (if (not (any-factp ((?f are-pozitia))
            (and (eq (fact-slot-value ?f entitate) caramida)
                 (eq (fact-slot-value ?f linie) ?ln)
                 (eq (fact-slot-value ?f coloana) ?c))))
   then
      (retract ?m)
      (assert (are-pozitia (entitate miner) (linie ?ln) (coloana ?c)))
      (printout t "Minerul mutat in sus: (" ?ln "," ?c ")" crlf)
   )
)

(defrule muta-miner-jos
   ?m <- (are-pozitia (entitate miner) (linie ?l) (coloana ?c))
   (are-pozitia (entitate comoara) (linie ?lt) (coloana ?ct))
   (test (< ?l ?lt))
   =>
   (bind ?ln (+ ?l 1))
   (if (not (any-factp ((?f are-pozitia))
            (and (eq (fact-slot-value ?f entitate) caramida)
                 (eq (fact-slot-value ?f linie) ?ln)
                 (eq (fact-slot-value ?f coloana) ?c))))
   then
      (retract ?m)
      (assert (are-pozitia (entitate miner) (linie ?ln) (coloana ?c)))
      (printout t "Minerul mutat in jos: (" ?ln "," ?c ")" crlf)
   )
)

(defrule miner-a-ajuns
   (are-pozitia (entitate miner) (linie ?l) (coloana ?c))
   (are-pozitia (entitate comoara) (linie ?l) (coloana ?c))
   =>
   (printout t "Felicitari! Comoara a fost gasita la (" ?l "," ?c ")" crlf)
   (halt)
)

