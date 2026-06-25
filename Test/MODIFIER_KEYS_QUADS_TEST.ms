clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../MenuBuildManager/MenuBuildManager.ms" )	--"./../MenuBuildManager/MenuBuildManager.ms"

filein( getFilenamePath(getSourceFileName()) + "/_INCLUDE-TEST_MACROSCRIPT.mcr" )	--"./_INCLUDE-TEST_MACROSCRIPT.mcr"


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
	quad_new = MenuBuildManager.quad ("_"+modifier_spec[1])
	
	quad_new.quad_modifier = modifier_spec[3]
	
	quad_1 = quad_new.getQuad 1
	
	quad_1 = quad_1.setTitle ("Title of " + modifier_spec[2] )
	
)

MenuBuildManager.installMenusNow update_quads:true load_default_cui_configuration:true
