
macroscript	_test_macro_A1
category:	"_TEST MENU A"
toolTip:	"Test Macro Tooltip"
buttontext:	"Test Macro Button Text"
icon:	"MENU:true"
(
	on execute do
		messageBox "_TEST MENU A"
		
		
	on altExecute type do
	(
		messageBox "altExecute"
	)
)





macroscript	_test_macro_B1
category:	"_TEST MENU B"
buttontext:	"Macro B 1"
icon:	"MENU:true"
(
	on execute do
		messageBox "Macro B 1"
)

macroscript	_test_macro_B2
category:	"_TEST MENU B"
buttontext:	"Macro B 2"
icon:	"MENU:true"
(
	on execute do
		messageBox "Macro B 2"
)

