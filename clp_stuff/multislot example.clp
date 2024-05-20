; java -classpath /DataExtra/AZx_Backup/Pack/test/Jess/Jess61p4/jess.jar jess.Main
; (batch "multislot example.clp")
;
; (run-app)
; (clear)
;

(deftemplate shopping-cart
	(slot market-name)
	(multislot contents))

(deffacts cart-list
(shopping-cart
	(market-name Conad)
	(contents milk meat biscuits marmelade apples)))


(defrule any-shopping-cart
(shopping-cart (contents $?items))
=>
(printout t "The cart contains " ?items crlf))

(defrule cart-containing-milk
(shopping-cart (contents $?before milk $?after))
=>
(printout t "The cart contains milk." crlf)
)
(defrule cart-containing-biscuits
(shopping-cart (contents $?before biscuits $?after))
=>
(printout t "Before biscuits: " ?before)
(printout t " and after: " ?after crlf crlf)
)
;; 
;; Jess> (batch "multislot example.clp") (reset) (run)
;; TRUE
;; Jess> TRUE
;; Jess> The cart contains (milk meat biscuits marmelade apples)
;; The cart contains milk.
;; Before biscuits: (milk meat) and after: (marmelade apples)
;; 
;; 3
;; Jess>