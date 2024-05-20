; java -classpath /DataExtra/AZx_Backup/Pack/test/Jess/Jess61p4/jess.jar jess.Main
; (batch "code_modules.clp")
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;    MAIN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(deffunction dice-throw ()
	    (+ (mod (random) 6) 1))


(deffunction double-dice ()
	(+ (dice-throw) (dice-throw)))


(deffunction run-app ()
  (watch all)
  (reset) ; the first module is implicitly MAIN
  (focus setup player-starter spareggio-setup) ; check-spareggio
  (run)
  (facts *))

; per far partire l'app utilizzare la seguente sequenza:
; 
; 	Jess> (clear)
; 	TRUE
; 	Jess> (batch "code_modules.clp")
; 	TRUE
; 	Jess> (run-app)



(deffacts inizio
	(add-player 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmodule setup)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffacts nomi-test
	(player 1 erimm)
	(player 2 toni) 
	(player 3 meni) 
	(player 4 bebi))



; si noti che per uscire dal loop bisogna proprio digitre "fine" nella linea di comando
; (read) legge unt esto ma credo lo restuisca come una lista di simboli
; da capire meglio come funziona
;
;; (defrule add-player-interattiva
;; 	?adpl <- (add-player ?n)
;; 	=>
;; 	(printout t "Inserire Nome, invio per chiudere: ")
;; 	(bind ?name (read))
;; 	(if (neq ?name fine) then 
;; 			(bind ?n1 (+ 1 ?n))
;; 			(assert (player ?n1 ?name))
;; 			(retract ?adpl)
;; 			(assert (add-player ?n1))))



 ; Sviluppo successivo stampare i nomi deipartecipanti, quindi modulo successivo, altrimeti parte troppo presto
 ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmodule player-starter)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(deffacts selettore-starter
	(starter 0))

(defrule dice-throw
	 (setup::player ?pos ?name) ; l'uso di unorderd diventa pernicioso
	 =>
	 (bind ?ran_val (double-dice))
	 (assert (dice-throw ?name ?ran_val)))

(defrule find-starter
	 ?strt <- (starter ?val)
	 (dice-throw ? ?val_ply&:(> ?val_ply ?val))
	 =>
	 (retract ?strt)
	 (assert (starter ?val_ply)))


(defrule remove-low
	 (starter ?val)
	 ?dtr <- (dice-throw ? ?val_ply&:(< ?val_ply ?val))
	 =>
	 (retract ?dtr))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Check

(defmodule spareggio-setup)

(deffacts selettore-starter
	(cnt-win 0))

(defrule assert-maxs
	(player-starter::dice-throw ?name ?valore)
	=>
	(assert (spareggio ?name ?valore)))

(defrule cnt-maxs
	?spar_rif <- (spareggio ?name ?valore)
	?cnt-rif <- (cnt-win ?val)
	=>
	(retract 
		?cnt-rif
		?spar_rif)
	(assert (cnt-win (+ 1 ?val))))



(defrule spareggio
	(cnt-win ?n&:(< 1 ?n))
	?str <- (player-starter::dice-throw ?name ?val_dice)
	(player-starter::starter ?val_dice)
	=>
	(retract ?str)
	(bind ?new_dice (double-dice))
	(assert (player-starter::dice-throw ?name ?new_dice)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Check
(defmodule check-spareggio)

(defrule spareggio-done
	?max <- (player-starter::starter ?)
	(spareggio-setup::cnt-win ?num&:(< 1 ?num))
	=>
	(retract ?max)
	(assert (player-starter::starter -1))
	(focus player-starter))







	 
	 
; WIP








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; (get-current-module)

; Jess> (set-current-module MAIN)
; player-starter
; Jess> (facts)
; f-0   (MAIN::initial-fact)
; f-2   (MAIN::player 1 toni)
; f-4   (MAIN::player 2 meni)
; For a total of 3 facts.
; Jess> 