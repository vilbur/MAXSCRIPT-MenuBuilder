clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/_INCLUDE-TEST_MACROSCRIPT.mcr" )	--"./_INCLUDE-TEST_MACROSCRIPT.mcr"


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
	MODIFY DEFAULT VIEWPORT QUAD
--------------------------------------------------------------------------------*/


MenuBuildManager = MenuBuildManager_v()

default_viewport_quad = MenuBuildManager.quad ("Default Viewport Quad" ) --type:#quad

quad_1 = default_viewport_quad.getQuad 1
quad_1.setTitle("TEST CHANGED TITLE")

quad_1.addItem "_TEST_CATEGORY" "_test_macro" title:("ITEM IN DEFAULT VIEWPORT QUAD")

MenuBuildManager.installMenusNow update_quads:true load_default_cui_configuration:true



