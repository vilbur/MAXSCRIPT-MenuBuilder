clearListener(); print("Cleared in: "+getSourceFileName())

-- filein( getFilenamePath(getSourceFileName()) + "/../include-QuadMenuManager.ms" )	--"./../include-QuadMenuManager.ms"



macroScript _test_macro
category:"_TEST_CATEGORY"
toolTip:"Test Macro Tooltip"
toolTip:"Test Macro Button Text"
(
	on execute do
		messageBox "SeparatorTestAction1" title:"Separator Test"
)

--modifier_specs = #(
--	#("None",	"None",	#nonePressed),
--	#("Shift",	"Shift",	#shiftPressed),
--	#("Ctrl",	"Ctrl",	#controlPressed),
--	#("Alt",	"Alt",	#altPressed),
--	#("ShiftCtrl",	"Shift+Ctrl",	#shiftAndControlPressed),
--	#("ShiftAlt",	"Shift+Alt",	#shiftAndAltPressed),
--	#("CtrlAlt",	"Ctrl+Alt",	#controlAndAltPressed),
--	#("ShiftAltCtrl",	"Shift+Alt+Ctrl",	#shiftAndAltAndControlPressed)
--)
--
--


/*------------------------------------------------------------------------------
	RUN TEST
--------------------------------------------------------------------------------*/

MenuBuildManager = MenuBuildManager_v()
format "MenuBuildManager: %\n" MenuBuildManager

--for modifier_spec in modifier_specs do 
(
	menu_new = MenuBuildManager.menu ("_TEST_MENU_A" ) --type:#quad

	menu_new.addItem "_TEST_CATEGORY" "_test_macro" title:("1 ITEM")
	menu_new.addSeparator()
	menu_new.addItem "_TEST_CATEGORY" "_test_macro" title:("2 ITEM")
	menu_new.addItem "_TEST_CATEGORY" "_test_macro" title:("3 ITEM")
)

MenuBuildManager.installMenusNow update_quads:true load_default_cui_configuration:true



