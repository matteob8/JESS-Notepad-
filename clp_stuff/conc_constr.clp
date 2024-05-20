; java -classpath /DataExtra/AZx_Backup/Pack/test/Jess/Jess61p4/jess.jar jess.Main
; (batch "conc_constr.clp")


;; some examples of connetive constraints

(deftemplate client 
	(slot city)
	(slot inhabs))

(deffacts some-city
	  (client (city Rome) (inhabs 1000))
	  (client (city Florence) (inhabs 500))
	  (client (city Venice) (inhabs 250))
	  (client (city Bangor) (inhabs 50)))


(defrule no-Bangor
	 (client (city ~Bangor))
	 =>
	 (printout t "Found a non-Bangor city" crlf))


(defrule double-city
	 (client (city ?name) (inhabs ?num))
	 (client (city ?name2) (inhabs ?y&=(* 2 ?num)))
	 =>
	 (printout t "The city of " ?name2 " has the doulbe of " ?name " (" ?y " vs " ?num ")" crlf))


