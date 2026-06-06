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

modifier_specs = #(
	#("None",	"None",	#nonePressed),
	#("Shift",	"Shift",	#shiftPressed),
	#("Ctrl",	"Ctrl",	#controlPressed),
	#("Alt",	"Alt",	#altPressed),
	#("ShiftCtrl",	"Shift+Ctrl",	#shiftAndControlPressed),
	#("ShiftAlt",	"Shift+Alt",	#shiftAndAltPressed),
	#("CtrlAlt",	"Ctrl+Alt",	#controlAndAltPressed),
	#("ShiftAltCtrl",	"Shift+Alt+Ctrl",	#shiftAndAltAndControlPressed)
)

/*------------------------------------------------------------------------------
	RUN TEST
--------------------------------------------------------------------------------*/

MenuBuildManager = MenuBuildManager_v()
format "MenuBuildManager: %\n" MenuBuildManager

for modifier_spec in modifier_specs do 
(
	quad_new = MenuBuildManager.menu ("_"+modifier_spec[1]) type:#quad
	--quad_new = MenuBuildManager.quad ("_"+modifier_spec[1])
	
	quad_new.quad_modifier = modifier_spec[3]
	
	quad_1 = quad_new.getQuad 1
	
	quad_1 = quad_1.setTitle ("Title of " + modifier_spec[2] )
	
	quad_1.addItem "_TEST_CATEGORY" "_test_macro" title:("ITEM OF:"+modifier_spec[2])
)

MenuBuildManager.installMenusNow update_quads:true load_default_cui_configuration:true

