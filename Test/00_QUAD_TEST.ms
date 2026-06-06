clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../MenuBuildManager/MenuBuildManager.ms" )	--"./../MenuBuildManager/MenuBuildManager.ms"

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

for letter in #( "A", "B", "C") do 
(
	menu_new = MenuBuildManager.menu ("_TEST_MENU_" + letter ) --type:#quad

	menu_new.addItem "_TEST_CATEGORY" "_test_macro" title:("1 ITEM "+letter)
	menu_new.addItem "_TEST_CATEGORY" "_test_macro" title:("2 ITEM "+letter)
	--menu_new.addSeparator()
	menu_new.addItem "_TEST_CATEGORY" "_test_macro" title:("3 ITEM "+letter)
)


MenuBuildManager.installMenusNow update_quads:true load_default_cui_configuration:true


QuadBuildManager = MenuBuildManager_v()
format "QuadBuildManager: %\n" QuadBuildManager

--for modifier_spec in modifier_specs do 
(
	quad_new = QuadBuildManager.quad ("_TEST_QUAD_A" ) --type:#quad
	
	quad_new.quad_modifier = #controlPressed

	quad_1 = quad_new.getQuad 1

	quad_1.addItem "_TEST_CATEGORY" "_test_macro" title:("1 ITEM QUAD")
	quad_1.addSeparator()
	quad_1.addItem "_TEST_CATEGORY" "_test_macro" title:("2 ITEM QUAD")
	quad_1.addItem "_TEST_CATEGORY" "_test_macro" --title:("3 ITEM QUAD")
	

	quad_2 = quad_new.getQuad 2

	quad_2.setTitle "Custom Quad Title"
	
	--quad_2.addMenu "_TEST_MENU_A" separators:1
	quad_2.addMenu "_TEST_MENU_A" separators:#(1,2)
	--quad_2.addMenu "_TEST_MENU_A" separators:#(1,2)
	quad_2.addMenu "_TEST_MENU_B" flat:false
	--quad_2.addSeparator()
	--quad_2.addItem "_TEST_CATEGORY" "_test_macro" title:("2 ITEM QUAD")
	--quad_2.addItem "_TEST_CATEGORY" "_test_macro" title:("3 ITEM QUAD")
	
	
	
)

QuadBuildManager.installMenusNow update_quads:true load_default_cui_configuration:true
