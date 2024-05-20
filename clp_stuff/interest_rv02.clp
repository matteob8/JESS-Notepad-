; java -classpath /DataExtra/AZx_Backup/Pack/test/Jess/Jess61p4/jess.jar jess.Main
; (batch "interest.clp")
;
; (run-app)
; (clear)
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;    MAIN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 


(deffunction run-app ()
;  (watch all)
  (reset) ; the first module is implicitly MAIN
;  (focus setup player-starter spareggio-setup check-spareggio) ;  FULL
  (run)
  (facts *))

; per far partire l'app utilizzare la seguente sequenza:
; 
; 	Jess> (clear)
; 	TRUE
; 	Jess> (batch "code_modules.clp")
; 	TRUE
; 	Jess> (run-app)



(deftemplate investment-data
	     (slot amount)
	     (slot quota)
	     (slot interest)
	     (slot periods))

(deffacts start-invest
   	(investment-data
	      (amount 0)
	      (quota 1000)
	      (interest 1.02)
	      (periods 15))
	     )


(defrule calculate
	 (investment-data
	     (amount ?am)
	     (quota ?q)
	     (interest ?inte)
	     (periods ?nper&:(< 0 ?nper)))
	     =>
	     (bind ?delta (* (+ ?am ?q) (- ?inte 1) 0.74))
	     (bind ?nper1 (- ?nper 1))
	     (assert
		(investment-data
			(amount (+ ?am ?delta ?q))
			(quota ?q)
			(interest ?inte)
			(periods ?nper1))))

;; Jess> (clear) (batch "interest.clp") (run-app)
;; TRUE
;; Jess> TRUE
;; Jess> f-0   (MAIN::initial-fact)
;; f-1   (MAIN::investment-data (amount 0) (quota 1000) (interest 1.02) (periods 15))
;; f-2   (MAIN::investment-data (amount 1014.8000000000001) (quota 1000) (interest 1.02) (periods 14))
;; f-3   (MAIN::investment-data (amount 2044.61904) (quota 1000) (interest 1.02) (periods 13))
;; f-4   (MAIN::investment-data (amount 3089.679401792) (quota 1000) (interest 1.02) (periods 12))
;; f-5   (MAIN::investment-data (amount 4150.206656938522) (quota 1000) (interest 1.02) (periods 11))
;; f-6   (MAIN::investment-data (amount 5226.429715461212) (quota 1000) (interest 1.02) (periods 10))
;; f-7   (MAIN::investment-data (amount 6318.580875250038) (quota 1000) (interest 1.02) (periods 9))
;; f-8   (MAIN::investment-data (amount 7426.895872203739) (quota 1000) (interest 1.02) (periods 8))
;; f-9   (MAIN::investment-data (amount 8551.613931112355) (quota 1000) (interest 1.02) (periods 7))
;; f-10   (MAIN::investment-data (amount 9692.977817292818) (quota 1000) (interest 1.02) (periods 6))
;; f-11   (MAIN::investment-data (amount 10851.233888988752) (quota 1000) (interest 1.02) (periods 5))
;; f-12   (MAIN::investment-data (amount 12026.632150545785) (quota 1000) (interest 1.02) (periods 4))
;; f-13   (MAIN::investment-data (amount 13219.426306373864) (quota 1000) (interest 1.02) (periods 3))
;; f-14   (MAIN::investment-data (amount 14429.873815708197) (quota 1000) (interest 1.02) (periods 2))
;; f-15   (MAIN::investment-data (amount 15658.235948180678) (quota 1000) (interest 1.02) (periods 1))
;; f-16   (MAIN::investment-data (amount 16904.777840213752) (quota 1000) (interest 1.02) (periods 0))
;; For a total of 17 facts.
;; Jess> 



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