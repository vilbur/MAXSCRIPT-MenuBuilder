clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../include-MenuManager.ms" )	--"./../include-MenuManager.ms"

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

/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/

quad_1 = QuadMenu.getQuad 1

quad_1.addItem "_TEST_CATEGORY" "_test_macro" title:("ITEM IN DEFAULT VIEWPORT QUAD")



/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/

quad_2 = QuadMenu.getQuad 2

--format "quad_2: %\n" quad_2

quad_2.clearItems()

quad_1.addItem "_TEST_CATEGORY" "_test_macro" title:("ITEM IN DEFAULT VIEWPORT QUAD")


MenuBuildManager.installMenusNow update_quads:true load_default_cui_configuration:true