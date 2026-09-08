clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../include-QuadMenuManager.ms" )	--"./../include-QuadMenuManager.ms"

filein( getFilenamePath(getSourceFileName()) + "/_INCLUDE-TEST_MACROSCRIPT.mcr" )	--"./_INCLUDE-TEST_MACROSCRIPT.mcr"


/*------------------------------------------------------------------------------
  
	TEST OF MENU AND QUAD MENUS using QuadMenuManager_v

------------------------------------------------------------------------------*/



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
	/* ADD FILES IN DIRECTORY */ 
	--MENU_MANAGER_GLOBAL.addMacrosToMenus ( getFilenamePath(getSourceFileName()) + "/../Test-Config-Files/Menus" )	--"./../Config-Files/Test/Menus/" )

	/* TEST ADDING ITEMS AFTER PARSING */ 
	menu_new = MENU_MANAGER_GLOBAL.menu ("MENU_BY_CODE" ) --type:#quad

	menu_new.addItem "_TEST_CATEGORY" "_test_macro" title:("ITEM by code")

)


/*==============================================================================

	RUN TESTS

================================================================================*/


/* DEFINE MENUS */ 
defineMenusItemsTest()


/*------------------------------------------------------------------------------
	CREATE MENU
--------------------------------------------------------------------------------*/
		
MENU_MANAGER_GLOBAL.createMenus()

