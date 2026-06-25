
macroScript _test_macro
category:"_TEST_CATEGORY"
toolTip:"Test Macro Tooltip"
buttontext:"Test Macro Button Text"
(
	on execute do
		messageBox "SeparatorTestAction1" title:"Separator Test"
		
		
	on altExecute type do
	(
		messageBox "altExecute"
	)
)




