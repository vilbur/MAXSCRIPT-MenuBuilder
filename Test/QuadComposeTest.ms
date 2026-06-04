 clearListener(); print("Cleared in: "+getSourceFileName())

global menu_rebuilder_file_version = 0.08
global MenuRebuilder
global MenuBuildManager

/* IMPORT HELPERS */ 
filein( getFilenamePath(getSourceFileName()) + "/Lib/printHelpers.ms" )	--"./Lib/printHelpers.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/createSavedTestMenuDataLevel.ms" )	--"./Lib/createSavedTestMenuDataLevel.ms"


/* PRODUCTION */

filein( getFilenamePath(getSourceFileName()) + "/../MenuBuildManager/MenuBuildManager.ms" )	--"./../MenuBuildManager/MenuBuildManager.ms"

/* DEVELOPEMNT */ 
--filein( getFilenamePath(getSourceFileName()) + "/../MenuRebuilder_update.ms" )	--"./../MenuRebuilder_update.ms"



/* 0.32 usage examples */

/* 1) Paste whole existing menu as whole single quad position. */

MenuBuildManager = MenuBuildManager_v()

MenuBuildManager.pasteMenuAsSingleQuad \
	"Foo Existing Menu" \
	quad_title:"Default Viewport Quad" \
	quad_position:1 \
	quad_modifier:#nonePressed \
	clear_defaul_menu:true

MenuBuildManager.build()


--/* 2) Compose one quad position from existing menus + custom items. */
--global MenuBuildManager
--MenuBuildManager = MenuBuildManager_v()
--
--quad_menu_definition = MenuBuildManager.getQuad "Default Viewport Quad" clear_defaul_menu:true
--quad_menu_definition.quad_modifier = #nonePressed
--
--quad_1 = quad_menu_definition.getQuad 1
--quad_1.clearItems()
--quad_1.addMenu "Foo Existing Menu" flat:true
--quad_1.addItem "_FOO_CATEGORY" "_MACRO_NAME" title:"Custom Item Between Menus"
--quad_1.addMenu "Bar Existing Menu" flat:true
--
--MenuBuildManager.waitForQuadBuild quad_menu_definition
--MenuBuildManager.build()
--
--
--/* Position index map used by getQuad: 1=#TopRight, 2=#TopLeft, 3=#BottomLeft, 4=#BottomRight */
