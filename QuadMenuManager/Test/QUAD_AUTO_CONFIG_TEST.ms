clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../include-QuadMenuManager.ms" )	--"./../../include-QuadMenuManager.ms"


macroScript _test_macro
category:"_TEST_CATEGORY"
toolTip:"Test Macro Tooltip"
buttontext:"Test Macro Button Text"
(
	on execute do
		messageBox "SeparatorTestAction1" title:"Separator Test"
)


current_dir = getFilenamePath(getSourceFileName())

cfg_dir = current_dir + "/Config-Files/"

MENU_MANAGER_GLOBAL.blacklist = #( "*\\bak*", "*-UNUSED*", "*rollout-OPTIONS\Menus.mcr" )

/*------------------------------------------------------------------------------
	MENU
--------------------------------------------------------------------------------*/
/* ADD ITEM */ 
MENU_MANAGER_GLOBAL.addItemToMenu "_TEST_CATEGORY" "_test_macro" "Custom Title"


/*------------------------------------------------------------------------------
	QUAD MENU
--------------------------------------------------------------------------------*/
MENU_MANAGER_GLOBAL.quadDir ( cfg_dir + "/QuadMenus/" )


/*------------------------------------------------------------------------------
	CREATE MENUS
--------------------------------------------------------------------------------*/


/* CREATE QUAD MENUS */ 
--MENU_MANAGER_GLOBAL.createMenus()


/* CREATE QUAD MENUS */ 
MENU_MANAGER_GLOBAL.createQuadMenus()