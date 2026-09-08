clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../include-QuadMenuManager.ms" )	--"./../include-QuadMenuManager.ms"

filein( getFilenamePath(getSourceFileName()) + "/_INCLUDE-TEST_MACROSCRIPT.mcr" )	--"./_INCLUDE-TEST_MACROSCRIPT.mcr"


/*
	Test right-click Default Viewport Quad replacement.
	Expected:
	1) version prints 0.91
	2) backup definition exists
	3) replacement modifier is #rightclick
	4) clear_default_menu is true
	5) native RMB quad is cleared/replaced after installMenusNow()
*/

MenuBuildManager = MenuBuildManager_v()


QuadMenu = MenuBuildManager.getQuad "Default Viewport Quad" modifiers:#rightclick

quad_1 = QuadMenu.getQuad 1

quad_1.addItem "_TEST_CATEGORY" "_test_macro" title:("ITEM IN DEFAULT VIEWPORT QUAD")



test_backup = MenuBuildManager.getDefaultViewportQuadBackup()

format "backup exists: %\n" (test_backup != undefined)
format "backup title: %\n" test_backup.title
format "replacement title: %\n" QuadMenu.title
format "replacement modifier: %\n" QuadMenu.quad_modifier
format "replacement clear default: %\n" QuadMenu.clear_default_menu

MenuBuildManager.installMenusNow update_quads:true load_default_cui_configuration:true
