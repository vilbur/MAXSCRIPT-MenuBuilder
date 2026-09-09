clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../include-MenuManager.ms" )	--"./../include-MenuManager.ms"

filein( getFilenamePath(getSourceFileName()) + "/_INCLUDE-TEST_MACROSCRIPT.mcr" )	--"./_INCLUDE-TEST_MACROSCRIPT.mcr"



/*------------------------------------------------------------------------------
  
	TEST OF MENU AND QUAD MENUS using MenuManager_v

------------------------------------------------------------------------------*/

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


/* CREATE INSTANCE FOR TESTING - FOR PRODUCTION CREATED IN "./../include-MenuManager.ms" */ 
global MENU_MANAGER_GLOBAL = MenuManager_v()


/* RESET QUADS */ 
MENU_MANAGER_GLOBAL.resetQuads() -- reset only quads




/*==============================================================================

	DEFINE QUAD MENUS

================================================================================*/  
	
/** Add quad items test
 */
function defineQuadItemsTest =
(
	--format "\n"; print ".defineQuadItemsTest()"
	
	for modifier_spec in modifier_specs do 
	(
		quad_new = MENU_MANAGER_GLOBAL.quad ("_TEST_QUAD" ) --type:#quad
		
		--quad_new.quad_modifier = #controlPressed
		quad_new.quad_modifier = modifier_spec[3]
		format "quad_new.quad_modifier: %\n" quad_new.quad_modifier
		
		
		/*------ BOTTOM LEFT QUAD ------*/
		quad_1 = quad_new.getQuad 1
	
		quad_1.addItem "_TEST_CATEGORY" "_test_macro" title:"ITEM 1 QUAD"
		quad_1.addSeparator()
		quad_1.addItem "_TEST_CATEGORY" "_test_macro" title:"TEST MACRO"

		
	)
)



/*==============================================================================

	RUN TESTS

================================================================================*/


/* DEFINE QUADS */ 
defineQuadItemsTest()



/*------------------------------------------------------------------------------
	CREATE MENUS
--------------------------------------------------------------------------------*/


/* CREATE QUAD MENUS */ 
MENU_MANAGER_GLOBAL.createQuadMenus()


/* SUCCESS MESSAGE */ 
--messageBox "Show quad by pressing:\n\nCTRL + RMB" title:"SHOW QUAD MENU"


