clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../include-MenuManager.ms" )	--"./../include-MenuManager.ms"

filein( getFilenamePath(getSourceFileName()) + "/_INCLUDE-TEST_MACROSCRIPT.mcr" )	--"./_INCLUDE-TEST_MACROSCRIPT.mcr"


/*------------------------------------------------------------------------------
  
	TEST OF MENU AND QUAD MENUS using MenuManager_v

------------------------------------------------------------------------------*/



/* CREATE INSTANCE FOR TESTING - FOR PRODUCTION CREATED IN "./../include-MenuManager.ms" */ 
global MENU_MANAGER_GLOBAL = MenuManager_v()

MENU_MANAGER_GLOBAL.Blacklist.menus = #( "*Black-List-Test.*" )


/* RESET MENUS */ 
MENU_MANAGER_GLOBAL.resetMenus() -- reset only menus



/*==============================================================================

	DEFINE MENUS

================================================================================*/


/** Add menus test
 */
function defineMenusItemsTest =
(
	/* ADDING ITEMS BY CODE */ 
	menu_new = MENU_MANAGER_GLOBAL.menu ("MENU_BY_CODE" ) --type:#quad
	
	menu_new.addItem "_TEST_CATEGORY" "_test_macro" title:("ITEM by code")
	
	/* ADD FILES IN DIRECTORY */ 
	MENU_MANAGER_GLOBAL.addMacrosToMenus ( getFilenamePath(getSourceFileName()) + "/Macros-Parser-Test-Files" )	--"./Macros-Parser-Test-Files/"

	/* ADDING ITEMS BY CODE AFTER PARSING */ 
	menu_new = MENU_MANAGER_GLOBAL.menu ("TEST MENU ORDER" ) --type:#quad
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

