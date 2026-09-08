clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../include-QuadMenuManager.ms" )	--"./../include-QuadMenuManager.ms"

filein( getFilenamePath(getSourceFileName()) + "/_INCLUDE-TEST_MACROSCRIPT.mcr" )	--"./_INCLUDE-TEST_MACROSCRIPT.mcr"



/*------------------------------------------------------------------------------
  
	TEST OF MENU AND QUAD MENUS using QuadMenuManager_v

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



/* CREATE INSTANCE FOR TESTING - FOR PRODUCTION CREATED IN "./../include-QuadMenuManager.ms" */ 
global MENU_MANAGER_GLOBAL = QuadMenuManager_v()


/* RESET MENUS AND QUAS */ 
MENU_MANAGER_GLOBAL.resetAll()

/* RESET MENUS */ 
MENU_MANAGER_GLOBAL.resetMenus() -- reset only menus

/* RESET QUADS */ 
MENU_MANAGER_GLOBAL.resetQuads() -- reset only quads


/*==============================================================================

	DEFINE MENUS

================================================================================*/


/** Add menus test
 */
function defineMenusItemsTest =
(
	--format "\n"; print ".createMenusTest()"
	
	for letter in #( "A", "B", "C") do 
	(
		menu_new = MENU_MANAGER_GLOBAL.menu ("_TEST_MENU_" + letter ) --type:#quad
	
		/* ADD ITEMS TO MENU */ 
		menu_new.addItem "_TEST_CATEGORY" "_test_macro" title:("ITEM 1 "+letter)
		
		menu_new.addItem "_TEST_CATEGORY" "_test_macro" title:("ITEM 2 "+letter)
	
		/* ADD NATIVE MAX ACTION */ 
		menu_new.addItem("Tools")("Hide Selection")	group:"Main UI" title:"Hide SELECTED"
		
	)
)



/*==============================================================================

	DEFINE QUAD MENUS

================================================================================*/  
	
/** Add quad items test
 */
function defineQuadItemsTest =
(
	--format "\n"; print ".defineQuadItemsTest()"
	
	--for modifier_spec in modifier_specs do 
	(
		quad_new = MENU_MANAGER_GLOBAL.quad ("_TEST_QUAD" ) --type:#quad
		
		quad_new.quad_modifier = #controlPressed
	
		
		
		/*------ BOTTOM LEFT QUAD ------*/
		quad_1 = quad_new.getQuad 1
	
		quad_1.addItem "_TEST_CATEGORY" "_test_macro" title:"ITEM 1 QUAD"
		quad_1.addSeparator()
		quad_1.addItem "_TEST_CATEGORY" "_test_macro" title:"TEST MACRO"
		
		
	
		/*------ TOP RIGHT QUAD ------*/
		quad_2 = quad_new.getQuad 2
	
		quad_2.setTitle "Custom Quad Title"
		
		quad_2.addMenu "_TEST_MENU_A" title:"MENU AS SUBMENU" separators:#(1,2) 
		
		quad_2.addSeparator()
		
		quad_2.addMenu "_TEST_MENU_B" flat:true
		
	)
)



/*==============================================================================

	RUN TESTS

================================================================================*/


/* DEFINE MENUS */ 
defineMenusItemsTest()


/* DEFINE QUADS */ 
defineQuadItemsTest()



/*------------------------------------------------------------------------------
	CREATE MENUS
--------------------------------------------------------------------------------*/
		
/* CREATE MENUS */ 
MENU_MANAGER_GLOBAL.createMenus()


/* CREATE QUAD MENUS */ 
MENU_MANAGER_GLOBAL.createQuadMenus()


/* SUCCESS MESSAGE */ 
messageBox "Show quad by pressing:\n\nCTRL + RMB" title:"SHOW QUAD MENU"


