 clearListener(); print("Cleared in: "+getSourceFileName())

global menu_rebuilder_file_version = 0.08
global MenuRebuilder
global MenuBuildManager

/* IMPORT HELPERS */ 
filein( getFilenamePath(getSourceFileName()) + "/Lib/printHelpers.ms" )	--"./Lib/printHelpers.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/createSavedTestMenuDataLevel.ms" )	--"./Lib/createSavedTestMenuDataLevel.ms"


/* PRODUCTION */

--filein( getFilenamePath(getSourceFileName()) + "/../MenuBuildManager/MenuBuildManager.ms" )	--"./../MenuBuildManager/MenuBuildManager.ms"

/* DEVELOPEMNT */ 
filein( getFilenamePath(getSourceFileName()) + "/../MenuRebuilder_update.ms" )	--"./../MenuRebuilder_update.ms"


/*  ====================================================================================================
    SECTION 09: TESTS
    ====================================================================================================
*/

function createTestMenuDefinition menu_title:"_MENU_REBUILDER_TEST_MENU" =
(
	menu_definition = MenuDefinition_v \
		type:#menu \
		title:menu_title

	menu_definition.addItem "_MENU_REBUILDER_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_1" title:"Menu Item 1"
	menu_definition.addItem "_MENU_REBUILDER_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_2" title:"Menu Item 2"

	submenu_definition = menu_definition.addMenu "Submenu 1"
	submenu_definition.addItem "_MENU_REBUILDER_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_3" title:"Submenu Item 1"

	menu_definition -- return
)


function createTestDefaultViewportQuadInjectionDefinition =
(
	quad_definition = MenuDefinition_v \
		type:#quad \
		title:"_MENU_REBUILDER_DEFAULT_QUAD_INJECT" \
		quad_modifier:#nonePressed

	quad_definition.data = #()

	quad_top_right = quad_definition.addQuad "Top Right" position:#TopRight
	quad_top_right.addItem "_MENU_REBUILDER_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_4" title:"Injected Top Right"

	quad_bottom_right = quad_definition.addQuad "Bottom Right" position:#BottomRight
	quad_bottom_right.addItem "_MENU_REBUILDER_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_5" title:"Injected Bottom Right"

	quad_definition -- return
)


function createTestCustomModifierQuadDefinition =
(
	quad_definition = MenuDefinition_v \
		type:#quad \
		title:"_MENU_REBUILDER_CUSTOM_SHIFT_CTRL_QUAD" \
		quad_modifier:#shiftAndControlPressed

	quad_definition.data = #()

	quad_top_right = quad_definition.addQuad "Top Right" position:#TopRight
	quad_top_right.addItem "_MENU_REBUILDER_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_6" title:"Custom Quad Item"

	quad_definition -- return
)


function testMenuBuildManagerDefaultQuadInject =
(
	global MenuBuildManager

	for macro_index = 1 to 6 do
	(
		generateMockMacroScript "_MENU_REBUILDER_TEST_CATEGORY" ("_MENU_REBUILDER_TEST_MACRO_" + (macro_index as string))
	)

	menu_definition = createTestMenuDefinition()
	quad_definition = createTestDefaultViewportQuadInjectionDefinition()

	menus_data = #(menu_definition, quad_definition)

	MenuBuildManager = MenuBuildManager_v menus_data:menus_data

	saved_menus_data = MenuBuildManager.run()

	saved_menus_data -- return
)


function testMenuBuildManagerCustomModifierQuad =
(
	global MenuBuildManager

	for macro_index = 1 to 6 do
	(
		generateMockMacroScript "_MENU_REBUILDER_TEST_CATEGORY" ("_MENU_REBUILDER_TEST_MACRO_" + (macro_index as string))
	)

	quad_definition = createTestCustomModifierQuadDefinition()

	MenuBuildManager = MenuBuildManager_v menus_data:#(quad_definition)

	saved_menus_data = MenuBuildManager.run()

	saved_menus_data -- return
)


function testMenuBuildManagerFromJson =
(
	global MenuBuildManager

	MenuBuildManager = MenuBuildManager_v()
	saved_menus_data = MenuBuildManager.loadSavedMenusDataFromJson()

	MenuBuildManager.saved_menus_data = saved_menus_data
	MenuBuildManager.merge_existing_data = false
	MenuBuildManager.registerCallback()

	saved_menus_data -- return
)


function testMenuGetterDefaultViewportQuadModify =
(
	global MenuBuildManager

	generateMockMacroScript "_MENU_REBUILDER_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_7"
	generateMockMacroScript "_MENU_REBUILDER_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_8"

	MenuBuildManager = MenuBuildManager_v()

	default_quad_definition = MenuBuildManager.menu \
		"Default Viewport Quad" \
		type:#quad \
		clear_defaul_menu:true

	top_right = default_quad_definition.addQuad "Top Right" position:#TopRight
	top_right.addItem "_MENU_REBUILDER_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_7" title:"Getter Top Right"

	bottom_right = default_quad_definition.addQuad "Bottom Right" position:#BottomRight
	bottom_right.addItem "_MENU_REBUILDER_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_8" title:"Getter Bottom Right"

	saved_menus_data = MenuBuildManager.run()

	saved_menus_data -- return
)




function testAddItemsToMenu index:undefined =
(
	global MenuBuildManager

	
	MenuBuildManager = MenuBuildManager_v()
	
	menu_definition = MenuBuildManager.menu "_MENU_ADD_ITEMS" type:#menu

		
	if index != undefined then
	(
		generateMockMacroScript "_MENU_REBUILDER_TEST_CATEGORY" ("_MENU_REBUILDER_TEST_MACRO_" + (index as string))

		menu_definition.addItem "_MENU_REBUILDER_TEST_CATEGORY" ("_MENU_REBUILDER_TEST_MACRO_"+index as string ) title:("Custom Quad Item "+index as string )
	)

	MenuBuildManager.menus_data = #(menu_definition)
	
	saved_menus_data = MenuBuildManager.run()

	saved_menus_data -- return
)

/** Test build quee
 */
function testBuildQuee =
(
	--format "\n"; print ".testBuildQuee()"
	
	manager = MenuBuildManager_v()
	
	menu_data_01 = createTestMenuDefinition menu_title:"_MENU_01"
	menu_data_02 = createTestMenuDefinition menu_title:"_MENU_02"
	menu_data_03 = createTestMenuDefinition menu_title:"_MENU_03"

	
	manager.addToBuildQuee menu_data_01
	manager.addToBuildQuee menu_data_02
	manager.addToBuildQuee menu_data_03
	
	manager.build()
)

/*  ====================================================================================================
    SECTION 10: MANUAL TEST CALLS
    ====================================================================================================


	------ ADD ITEMS ONE BY ONE
	testAddItemsToMenu()
	testAddItemsToMenu index:1
	testAddItemsToMenu index:2
	

    ------ Injects into existing Default Viewport Quad:
    saved_menus_data = testMenuBuildManagerDefaultQuadInject()

    ------ Creates custom Ctrl+Shift+RMB quad:
    saved_menus_data = testMenuBuildManagerCustomModifierQuad()

    ------ Reload from JSON:
    saved_menus_data = testMenuBuildManagerFromJson()

    ------ Open JSON manager:
    openMenuBuildManagerJsonRollout()

    ------ Clear JSON:
    menu_manager = MenuBuildManager_v()
    menu_manager.clearJsonFile()

    ------ Debug qmnx roots:
    qmnx_clear = QuadDefaultQmnxClear_v()
    qmnx_clear.printQmnxRoot @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2026 - 64bit\ENU\scripts\MAXSCRIPT-MenuBuilder\MenuRebuilder\qmnx\topRight-clear.qmnx"
    qmnx_clear.printQmnxRoot @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2026 - 64bit\ENU\scripts\MAXSCRIPT-MenuBuilder\MenuRebuilder\qmnx\bottomRight-clear.qmnx"


	------- TEST BUILD QUEE
	testBuildQuee()

	====================================================================================================*/

	testBuildQuee()

	----testAddItemsToMenu()
	

    -- Injects into existing Default Viewport Quad:
    --saved_menus_data = testMenuBuildManagerDefaultQuadInject()
    --
    ---- Creates custom Ctrl+Shift+RMB quad:
    --saved_menus_data = testMenuBuildManagerCustomModifierQuad()
	

	
    ---- Reload from JSON:
    --saved_menus_data = testMenuBuildManagerFromJson()
    --
    ---- Open JSON manager:
    --openMenuBuildManagerJsonRollout()
    --
    ---- Clear JSON:
    --menu_manager = MenuBuildManager_v()
    --menu_manager.clearJsonFile()
    --
    ---- Debug qmnx roots:
    --qmnx_clear = QuadDefaultQmnxClear_v()
    --qmnx_clear.printQmnxRoot @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2026 - 64bit\ENU\scripts\MAXSCRIPT-MenuBuilder\MenuRebuilder\qmnx\topRight-clear.qmnx"
    --qmnx_clear.printQmnxRoot @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2026 - 64bit\ENU\scripts\MAXSCRIPT-MenuBuilder\MenuRebuilder\qmnx\bottomRight-clear.qmnx"


/*------------------------------------------------------------------------------
	DEV HELPERS
--------------------------------------------------------------------------------*/


/* DEVELOPEMNT: RESET MENUS CONFIG

(maxOps.GetICuiMenuMgr()).LoadConfiguration((maxOps.GetICuiMenuMgr()).GetDefaultConfiguration())

(maxOps.GetICuiMenuMgr()).GetCurrentConfiguration()

*/ 

/* DEVELOPEMNT: RESET QUADS CONFIG

(maxOps.GetICuiQuadMenuMgr()).LoadConfiguration((maxOps.GetICuiQuadMenuMgr()).GetDefaultConfiguration())

(maxOps.GetICuiQuadMenuMgr()).GetCurrentConfiguration()

*/ 
