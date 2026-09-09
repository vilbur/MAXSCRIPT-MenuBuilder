clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../Lib/MenuBuildManager/MenuBuildManager.ms" )	--"./../Lib/MenuBuildManager/MenuBuildManager.ms"


/*------------------------------------------------------------------------------
  
	TEST OF MENU using MenuBuildManager

------------------------------------------------------------------------------*/

MenuBuildManager = MenuBuildManager_v()
format "Manager version: %, native cache: %\n" MenuBuildManager.version (MenuBuildManager.getNativeDataFilePath())



/* REMOVE MENUS before test */ 
MenuBuildManager.removeMenu "_Custom-Menus"
--MenuBuildManager.removeMenu "_TEST_MENU_B"

MenuBuildManager.updateMenus()



menu_new = MenuBuildManager.menu ("_TEST_MENU_A" ) --type:#quad

menu_test_delete = MenuBuildManager.menu ("_TEST_MENU_B" ) --type:#quad

menu_new.addItem "_TEST_CATEGORY" "_test_macro" title:("1 ITEM")
menu_new.addItem "_TEST_CATEGORY" "_test_macro" title:("2 ITEM")
menu_new.addItem "_TEST_CATEGORY" "_test_macro" title:("3 ITEM")

/* ADD DEFAULT ACTION */ 
menu_new.addSeparator()

menu_new.addItem("Tools")("Hide Selection")	group:"Main UI" title:"Hide SELECTED"



/* INSTALL MENUS */ 
MenuBuildManager.installMenusNow update_quads:true load_default_cui_configuration:true



/* REMOVE MENUS MENUS */ 
--MenuBuildManager.removeMenu "_Custom-Menus"
MenuBuildManager.removeMenu "_TEST_MENU_B"

/* UPDATE MENUS in UI */ 
MenuBuildManager.updateMenus()