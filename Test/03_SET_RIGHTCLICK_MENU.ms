clearListener(); print("Cleared in: "+getSourceFileName())

 filein( getFilenamePath(getSourceFileName()) + "/../include-QuadMenuManager.ms" )	--"./../include-QuadMenuManager.ms"



macroScript _test_macro
category:"_TEST_CATEGORY"
toolTip:"Test Macro Tooltip"
buttontext:"Test Macro Button Text"
(
	on execute do
		messageBox "SeparatorTestAction1" title:"Separator Test"
)
--
----modifier_specs = #(
----	#("None",	"None",	#nonePressed),
----	#("Shift",	"Shift",	#shiftPressed),
----	#("Ctrl",	"Ctrl",	#controlPressed),
----	#("Alt",	"Alt",	#altPressed),
----	#("ShiftCtrl",	"Shift+Ctrl",	#shiftAndControlPressed),
----	#("ShiftAlt",	"Shift+Alt",	#shiftAndAltPressed),
----	#("CtrlAlt",	"Ctrl+Alt",	#controlAndAltPressed),
----	#("ShiftAltCtrl",	"Shift+Alt+Ctrl",	#shiftAndAltAndControlPressed)
----)
----
----
--
--
--/*------------------------------------------------------------------------------
--	MODIFY DEFAULT VIEWPORT QUAD
----------------------------------------------------------------------------------*/
--
--
--MenuBuildManager = MenuBuildManager_v()
--
--default_viewport_quad = MenuBuildManager.quad ("Default Viewport Quad" ) --type:#quad
--
--quad_1 = default_viewport_quad.getQuad 1
--quad_1.setTitle("TEST CHANGED TITLE")
--
--quad_1.addItem "_TEST_CATEGORY" "_test_macro" title:("ITEM IN DEFAULT VIEWPORT QUAD")
--
--MenuBuildManager.installMenusNow update_quads:true load_default_cui_configuration:true
--
/*
Test right-click Default Viewport Quad replacement.
Expected:
1) version prints 0.91
2) backup definition exists
3) replacement modifier is #rightclick
4) clear_default_menu is true
5) native RMB quad is cleared/replaced after installMenusNow()
*/
(
	test_manager = MenuBuildManager_v()

	format "MenuBuildManager_v.version: %\n" test_manager.version

	test_quad = test_manager.getQuad "Default Viewport Quad" modifiers:#rightclick

	quad_1 = test_quad.getQuad 1
	quad_1.addItem "_TEST_CATEGORY" "_test_macro" title:("ITEM IN DEFAULT VIEWPORT QUAD")

	test_backup = test_manager.getDefaultViewportQuadBackup()

	format "backup exists: %\n" (test_backup != undefined)
	format "backup title: %\n" test_backup.title
	format "replacement title: %\n" test_quad.title
	format "replacement modifier: %\n" test_quad.quad_modifier
	format "replacement clear default: %\n" test_quad.clear_default_menu

	test_manager.installMenusNow update_quads:true load_default_cui_configuration:true
)