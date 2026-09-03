clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../Test/_INCLUDE-TEST_MACROSCRIPT.mcr" )	--"./../../Test/_INCLUDE-TEST_MACROSCRIPT.mcr"



/*------------------------------------------------------------------------------
	RUN TEST
--------------------------------------------------------------------------------*/

MenuBuildManager = MenuBuildManager_v()


--menu_new = MenuBuildManager.menu ("_TEST_MENU_A" ) --type:#quad
----menu_new = MenuBuildManager.menu ("_TEST_MENU_B" ) --type:#quad
--
--
--menu_new.addItem "_TEST_CATEGORY" "_test_macro" title:("1 ITEM")
--menu_new.addSeparator()
--menu_new.addItem "_TEST_CATEGORY" "_test_macro" title:("2 ITEM")
--menu_new.addItem "_TEST_CATEGORY" "_test_macro" title:("3 ITEM")
--


--MenuBuildManager.installMenusNow update_quads:true load_default_cui_configuration:true



MenuBuildManager.removeMenu "_Custom-Menus"


--
--/* RESET QUADS */ 
--MenuBuildManager.clearDataFile()
--
--/* UPDATE MENU & QUADS */ 
--MenuBuildManager.installMenusNow()
