; java -classpath /DataExtra/AZx_Backup/Pack/test/Jess/Jess61p4/jess.jar jess.Main


(watch all)

(defrule start-analyze
	 (initial-fact)
	 =>
	 (focus WORK)
	 (assert (continua))
	 (printout t crlf "..... End of session ....." crlf))


(defrule va-avanti
	 (continua)
	 =>
	 (printout t crlf "..... After End of session ....." crlf))

(defmodule WORK)




(deftemplate job (slot salary))

(defrule continuaimo
	 (ancora-continua)
	 =>
	 (quit-job))

(defmodule HOME)

(deftemplate hobby (slot name) (slot income))

; (undefrule WORK::quit-job)
(defrule WORK::quit-job 
(WORK::job (salary ?s))
(HOME::hobby (income ?i&:(> ?i (/ ?s 2))))
(MAIN::mortgage-payment ?m&:(< ?m ?i))
=>
(call-boss)
;(return)
(focus MAIN)
(assert (ancora-continua)))
;(quit-job))




(deffunction call-boss ()
	    (printout t "Bye bye Boss" crlf))

(deffunction quit-job ()
	    (printout t "Start new way!" crlf))

(reset)

(assert (WORK::job (salary 1500)))

(assert (MAIN::mortgage-payment 1000))

(assert (HOME::hobby (name apiculutura) (income 1100)))

(run)