clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../include-QuadMenuManager.ms" )	--"./../include-QuadMenuManager.ms"

filein( getFilenamePath(getSourceFileName()) + "/_INCLUDE-TEST_MACROSCRIPT.mcr" )	--"./_INCLUDE-TEST_MACROSCRIPT.mcr"


/*------------------------------------------------------------------------------
  
	TEST OF MENU AND QUAD MENUS using QuadMenuManager_v

------------------------------------------------------------------------------*/

cfg_files = getFilenamePath(getSourceFileName()) + "/../Config-Files/Test" --"./../Config-Files/Test/"


/* CREATE INSTANCE FOR TESTING - FOR PRODUCTION CREATED IN "./../include-QuadMenuManager.ms" */ 
global MENU_MANAGER_GLOBAL = QuadMenuManager_v()
--MENU_MANAGER_GLOBAL.blacklist = #( "*\\bak*", "*-UNUSED*", "*rollout-OPTIONS\Menus.mcr" )


/* RESET MENUS */ 
MENU_MANAGER_GLOBAL.resetMenus() -- reset only menus



/*==============================================================================

	DEFINE MENUS

================================================================================*/


/** Add menus test
 */
function defineMenusItemsTest =
(
	--format "\n"; print ".createMenusTest()"
	MENU_MANAGER_GLOBAL.addMacrosToMenus ( cfg_files + "/Menus" )	--"./../Config-Files/Test/Menus/" )
	
	--for letter in #( "A", "B", "C") do 
	--(
	--	menu_new = MENU_MANAGER_GLOBAL.menu ("_TEST_MENU_" + letter ) --type:#quad
	--
	--	/* ADD ITEMS TO MENU */ 
	--	menu_new.addItem "_TEST_CATEGORY" "_test_macro" title:("ITEM 1 "+letter)
	--	
	--	menu_new.addItem "_TEST_CATEGORY" "_test_macro" title:("ITEM 2 "+letter)
	--
	--	/* ADD NATIVE MAX ACTION */ 
	--	menu_new.addItem("Tools")("Hide Selection")	group:"Main UI" title:"Hide SELECTED"
	--	
	--)
)


/*==============================================================================

	RUN TESTS

================================================================================*/


/* MENUS */ 
defineMenusItemsTest()


/*------------------------------------------------------------------------------
	CREATE MENU
--------------------------------------------------------------------------------*/
		
--createDialog MenuManagerUI_ROLLOUT width:380 --1024


/* CREATE MENUS */ 
MENU_MANAGER_GLOBAL.createMenus()


/* SUCCESS MESSAGE */ 
--messageBox "Show quad by pressing:\n\nCTRL + RMB" title:"SHOW QUAD MENU"



