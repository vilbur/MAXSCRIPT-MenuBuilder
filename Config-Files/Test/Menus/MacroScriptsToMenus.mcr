
macroscript	_test_macro
category:	"_TEST_MENU"
toolTip:	"Test Macro Tooltip"
buttontext:	"Test Macro Button Text"
icon:	"MENU:true"
(
	on execute do
		messageBox "SeparatorTestAction1" title:"Separator Test"
		
		
	on altExecute type do
	(
		messageBox "altExecute"
	)
)




