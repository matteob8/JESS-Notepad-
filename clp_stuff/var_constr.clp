; java -classpath /DataExtra/AZx_Backup/Pack/test/Jess/Jess61p4/jess.jar jess.Main

## Literal constraints

(defrule literal-values
(letters (__data b c))
=>)

(defrule literal-values
(letters b c)
=>)

(assert (letters b c))

seems that the orderd fact rules does non compile!


## Variable constraints

(defrule repeated-variables
(a ?x)
(b ?x)
=>
(printout t "?x is " ?x crlf))

(watch activations)

(deffacts repeated-variable-facts
(a 2)
(a 5)
(b 2)
(b 3)
(a 2)
(b 2)
(a 3)
(b 5)
(a 2)
(a 7)
)
(facts)
(reset)

(run)

(exit)




sembra trovi tutte le coppie di fatti che rispettano la regola-
- [ ] da capire in quale ordine i fatti sono consderati

Si noti che i fatti DUPLICATI vengono RIMOSSI!

- [ ] come automatizzare il cilco di prova-modifica-prova?
- [ ] come installare il jess-mode in emacs?



Jess> (clear)
TRUE
Jess> (defrule repeated-variables
(a ?x)
(b ?x)
=>
(printout t "?x is " ?x crlf))
TRUE
Jess> (watch activations)
TRUE
Jess> TRUE
Jess> (deffacts repeated-variable-facts
(a 2)
(a 5)
(b 2)
(b 3)
(a 2)
(b 2)
(a 3)
(b 5)
(a 2)
(a 7)
)
TRUE
Jess> (reset)
==> Activation: MAIN::repeated-variables :  f-1, f-3
==> Activation: MAIN::repeated-variables :  f-5, f-4
==> Activation: MAIN::repeated-variables :  f-2, f-6
TRUE
Jess> (facts)
f-0   (MAIN::initial-fact)
f-1   (MAIN::a 2)
f-2   (MAIN::a 5)
f-3   (MAIN::b 2)
f-4   (MAIN::b 3)
f-5   (MAIN::a 3)
f-6   (MAIN::b 5)
f-7   (MAIN::a 7)
For a total of 8 facts.
Jess> (run)
?x is 5
?x is 3
?x is 2
3
Jess>


# Return value constraints (139)

- [ ] is there a way to get the elaboarted result as a variabile without resorting to the extended form?

## Extenden form
(deftemplate item (slot price) (slot mileage))


(defrule price-duble
(item (price ?x))
(item (price ?y&:(eq ?y (* ?x 2))))
=> (printout t "?x is " ?x crlf))


(deffacts items-facts
	(item (price 125))
	(item (price 242))
	(item (price 1))
	(item (price 250))
	(item (price 121) (mileage 234)))


## Compact form with =

(defrule price-duble-cmpct
(item (price ?x))
(item (price =(* ?x 2)))
=> (printout t "compact = ?x is " ?x crlf))