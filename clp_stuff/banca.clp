; java -classpath /DataExtra/AZx_Backup/Pack/test/Jess/Jess61p4/jess.jar jess.Main
; Dati presi dal numero 195 di Altroconsumo InTasca pag. 13
;
; (batch "banca.clp")
; (reset) (run) (facts)
;
(deftemplate banca
	(slot nome)
	(slot nome-conto)
	
;; (deffacts setup-max-search
;; 	(max-rend 0))

(deffacts db-banks
	(banca	(nome Bper) (nome-conto Grande)	(tasso 0.1))
 	(banca	(nome Bper) (nome-conto "Giovani 13-17")	(tasso 0.05))
 ;;	(banca	(nome "BCC Prealpi") (nome-conto "Deposito risparmio") (tasso 2.5))
 ;;	(banca	(nome "Crédit Agricol") (nome-conto "Vyp junior")	(tasso 0.5))
 	(banca	(nome Extrabanca) (nome-conto Extrakids)	(tasso 0.25))
	 	(banca	(nome Fittizia) (nome-conto None)	(tasso 0.25))

 	(banca	(nome "Poste Italiano") (nome-conto "Io Cresco")	(tasso 0.01))
 	(banca	(nome "Poste Italiano") (nome-conto "Io Conosco")	(tasso 0.01))
 	(banca	(nome "Poste Italiano") (nome-conto "Io Capisco")	(tasso 0.01))
 	(banca	(nome Unicredit) (nome-conto "Genius Bimbi")	(tasso 0.2))
 	(banca	(nome Unicredit) (nome-conto "Genius Teen")	(tasso 0.2))
	)

(defrule max-libretto-rendimento
	?rif-max <- (max-rend ?val)
	(banca (tasso ?val_tasso&:(> ?val_tasso ?val)))
	=>
	(retract ?rif-max)
	(assert (max-rend ?val_tasso)))
	
(defrule show-me-max
"Questa regola permette di selezioanre il conto massimo senza ricorrere ai moduli"
	(banca (tasso ?val) (nome ?nome-banca) (nome-conto ?nome-cnt))
	(not(banca (tasso ?val_tasso&:(> ?val_tasso ?val)))) ; vera se non c'è nessun valore maggiore
	=>
	(printout t "Miglior tasso " ?val " --> Banca: " ?nome-banca "   Conto: " ?nome-cnt crlf)
	)
	
;; Jess> (batch "banca.clp")
;; TRUE
;; Jess> (reset) (run) (facts)
;; TRUE
;; Jess> Miglior tasso 0.25 --> Banca: Fittizia   Conto: None
;; Miglior tasso 0.25 --> Banca: Extrabanca   Conto: Extrakids
;; 4
;; Jess> f-0   (MAIN::initial-fact)
;; f-2   (MAIN::banca (nome Bper) (nome-conto Grande) (tasso 0.1))
;; f-3   (MAIN::banca (nome Bper) (nome-conto "Giovani 13-17") (tasso 0.05))
;; f-4   (MAIN::banca (nome Extrabanca) (nome-conto Extrakids) (tasso 0.25))
;; f-5   (MAIN::banca (nome Fittizia) (nome-conto None) (tasso 0.25))
;; f-6   (MAIN::banca (nome "Poste Italiano") (nome-conto "Io Cresco") (tasso 0.01))
;; f-7   (MAIN::banca (nome "Poste Italiano") (nome-conto "Io Conosco") (tasso 0.01))
;; f-8   (MAIN::banca (nome "Poste Italiano") (nome-conto "Io Capisco") (tasso 0.01))
;; f-9   (MAIN::banca (nome Unicredit) (nome-conto "Genius Bimbi") (tasso 0.2))
;; f-10   (MAIN::banca (nome Unicredit) (nome-conto "Genius Teen") (tasso 0.2))
;; f-12   (MAIN::max-rend 0.25)
;; For a total of 11 facts.
;; Jess>