; java -classpath /DataExtra/AZx_Backup/Pack/test/Jess/Jess61p4/jess.jar jess.Main
; (batch "code_modules.clp")
;
; (run-app)
; (clear)
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
  (focus setup player-starter spareggio-setup check-spareggio) ;  FULL
;  (focus setup player-starter spareggio-setup) ;  Half
; (focus setup player-starter) ;  Half
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
	
(deffacts valori-test 						; DEBUG al posto di "dice-throw"
	(player-starter::dice-throw toni 12)
	(player-starter::dice-throw meni 12)
	(player-starter::dice-throw bebi 12)
	(player-starter::dice-throw erimm 5))
	
; (defrule dice-throw
; 	 (setup::player ?pos ?name) ; l'uso di unorderd diventa pernicioso
; 	 =>
; 	 (bind ?ran_val (double-dice))
; 	 (assert (dice-throw ?name ?ran_val)))

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
	 

(defrule re-restart-conversion
	 ?ria <- (spareggio-dice-throw ?name ?val)
	 =>
	 (retract ?ria)
	 (assert (dice-throw ?name ?val)))
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






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Check
(defmodule check-spareggio)

(deffacts conta-ripartenze
	(cnt-ripartenze 0))


(defrule spareggio-done
	?ripa <- (cnt-ripartenze ?cntrp)
	?max <- (player-starter::starter ?n&:(< 0 ?n))
	(spareggio-setup::cnt-win ?num&:(< 1 ?num))
	=>
	(printout t "==================== Review ====================" crlf)
	(retract 
		?max
		?ripa)
	(assert 
		(player-starter::starter -1)
		(cnt-ripartenze (+ 1 ?cntrp)))
		(focus ri-assegna-valori player-starter spareggio-setup))
;
; Attenzione: Focus mette nello stack dei moduli quelli indicati nel comando. Quindi vengono messi sopra a quello attuale. Una volta che tali focus terminano lo stack si svuota e resta questo stesso modulo che ha messo gli altri focus sopra, quindi non è necessario rimettere questo modulo nella lista: viene fatto implicitamente dal meccanismo degli stack. Vedi nota sotto:
; 
;  (focus ri-assegna-valori player-starter spareggio-setup check-spareggio)
;
;   è come:
;
;  (focus ri-assegna-valori player-starter spareggio-setup)
;
;
; 

; 
; In generale: Fare attenzione se si elimina e inseriscono fatti usati nel LHS della stessa rule.
; 	Lo stesso concetto va tenuto in considerazione tra rules nello stesso modulo: se una modifica i facts usati dall'altra nella sua LHS e viceversa, si possono creare loops o effetti indesiderati.
; I moduli son utili anche come namespaces: si può usare lo stesso simbolo in diverse rules. Bisogna fare attenzione a cosa ci si riferisce nelle rules, cioè bisogna fare attenzione a non dimenticare il namespace
; 
; la definizione implicita di un oreder facts potrebbe creare problemi, visto che i deftempaltes impliciti si creano solo dopo che è stato creato il fact
; 
; Tutto questo porta alla nota che il codice delle rules va PENSATO e non buttato giù con la tastiera.
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Check
(defmodule ri-assegna-valori)



(defrule spareggio
	?str <- (player-starter::dice-throw ?name ?val_dice)
	?spar <- (spareggio-setup::cnt-win ?num&:(< 0 ?num))
	=>
	(retract 
		?str
		?spar)
	(bind ?new_dice (double-dice))
	(assert
		(spareggio-setup::cnt-win (- ?num 1))
		(player-starter::spareggio-dice-throw ?name ?new_dice)))

		
	 
	 
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