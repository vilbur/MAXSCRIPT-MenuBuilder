clearListener(); print("Cleared in: "+getSourceFileName())

global menu_rebuilder_file_version = 0.08
global MenuRebuilder
global MenuBuildManager

/* IMPORT HELPERS */ 
--filein( getFilenamePath(getSourceFileName()) + "/Lib/printHelpers.ms" )	--"./Lib/printHelpers.ms"
--filein( getFilenamePath(getSourceFileName()) + "/Lib/createSavedTestMenuDataLevel.ms" )	--"./Lib/createSavedTestMenuDataLevel.ms"

--filein( getFilenamePath(getSourceFileName()) + "/../MenuBuildManager/MenuBuildManager.ms" )	--"./../MenuBuildManager/MenuBuildManager.ms"

filein( getFilenamePath(getSourceFileName()) + "/../../MAXSCRIPT-UI-framework/Lib/Menus/MenuRebuilder_update.ms" )	--"./../../MAXSCRIPT-UI-framework/Lib/Menus/MenuRebuilder_update.ms"

/* IMPORT LIBRARY */ 

	/*  ====================================================================================================
    SECTION 08: PRINT AND DEBUG HELPERS
    ====================================================================================================
*/


/*  Prints simplified title-key menu dictionary.
    Used only for checking source test data.
*/
function printSourceMenuDictionary dictionary_value indent:"" =
(
	if dictionary_value == undefined then
	(
		format "%source dictionary is undefined\n" indent
	)
	else if classOf dictionary_value != Dictionary then
	(
		format "%source value is not Dictionary: %\n" indent dictionary_value
	)
	else
	(
		dictionary_keys = GetDictKeys dictionary_value

		for key_name in dictionary_keys do
		(
			item_value = dictionary_value[key_name]

			if classOf item_value == Dictionary then
			(
				format "%SUBMENU: %\n" indent key_name
				printSourceMenuDictionary item_value indent:(indent + "    ")
			)
			else
			(
				format "%ITEM: % -> category: %, macro: %\n" indent key_name item_value[1] item_value[2]
			)
		)
	)

	ok -- return
)


/*  Prints saved menu items structure.
    Shows GUID keys, action data and nested submenu data.
*/
function printSavedMenuItems saved_items indent:"" =
(
	if saved_items == undefined then
	(
		format "%saved_items is undefined\n" indent
	)
	else if classOf saved_items != Dictionary then
	(
		format "%saved_items is not Dictionary: %\n" indent saved_items
	)
	else
	(
		saved_guid_array = GetDictKeys saved_items

		for saved_guid in saved_guid_array do
		(
			item_data = saved_items[saved_guid]

			if classOf item_data == Dictionary then
			(
				try
				(
					if HasDictValue item_data #items then
					(
						format "%SUBMENU GUID: %\n" indent saved_guid
						format "%    title: %\n" indent item_data[#title]
						printSavedMenuItems item_data[#items] indent:(indent + "    ")
					)
					else
					(
						format "%ITEM GUID: %\n" indent saved_guid
						format "%    title: %\n" indent item_data[#title]
						format "%    category: %\n" indent item_data[#category]
						format "%    macro: %\n" indent item_data[#macro]
					)
				)
				catch
				(
					format "%INVALID GUID: % value: %\n" indent saved_guid item_data
				)
			)
			else
			(
				format "%INVALID GUID: % value: %\n" indent saved_guid item_data
			)
		)
	)

	ok -- return
)


/*  Prints saved quad quadrant array.
    Shows quadrant title, position and item data.
*/
function printSavedQuadMenus quad_menus indent:"" =
(
	if quad_menus == undefined then
	(
		format "%quad_menus is undefined\n" indent
	)
	else if classOf quad_menus != Array then
	(
		format "%quad_menus is not array: %\n" indent quad_menus
	)
	else
	(
		for quad_index = 1 to quad_menus.count do
		(
			quad_data = quad_menus[quad_index]

			format "%QUAD INDEX: %\n" indent quad_index
			format "%    title: %\n" indent quad_data[#title]
			format "%    quad_position: %\n" indent quad_data[#quad_position]
			format "%    quad_menu_id: %\n" indent quad_data[#quad_menu_id]

			printSavedMenuItems quad_data[#items] indent:(indent + "    ")
		)
	)

	ok -- return
)


/*  Prints one saved root menu data.
    Root data contains version, id, title, type and items.
*/
function printSavedMenuData saved_menu_data indent:"" =
(
	if saved_menu_data == undefined then
	(
		format "%saved_menu_data: undefined\n" indent
	)
	else if classOf saved_menu_data != Dictionary then
	(
		format "%saved_menu_data is not Dictionary: %\n" indent saved_menu_data
	)
	else
	(
		format "%version: %\n" indent saved_menu_data[#version]
		format "%id: %\n" indent saved_menu_data[#id]
		format "%title: %\n" indent saved_menu_data[#title]
		format "%type: %\n" indent saved_menu_data[#type]
		format "%quad_context_id: %\n" indent saved_menu_data[#quad_context_id]
		format "%quad_modifier: %\n" indent saved_menu_data[#quad_modifier]
		format "%quad_position: %\n" indent saved_menu_data[#quad_position]
		format "%quad_menu_id: %\n" indent saved_menu_data[#quad_menu_id]

		if HasDictValue saved_menu_data #quad_menus then
		(
			if saved_menu_data[#quad_menus].count > 0 then
			(
				printSavedQuadMenus saved_menu_data[#quad_menus] indent:(indent + "    ")
			)
		)

		printSavedMenuItems saved_menu_data[#items] indent:(indent + "    ")
	)

	ok -- return
)


/*  Prints array of saved menu root data.
    Used after MenuBuildManager_v.run.
*/
function printSavedMenusData saved_menus_data =
(
	if saved_menus_data == undefined then
	(
		format "saved_menus_data: undefined\n"
	)
	else if classOf saved_menus_data != Array then
	(
		format "saved_menus_data is not Array: %\n" saved_menus_data
	)
	else
	(
		for menu_index = 1 to saved_menus_data.count do
		(
			format "\n===== SAVED MENU DATA % =====\n" menu_index
			printSavedMenuData saved_menus_data[menu_index] indent:"    "
		)
	)

	ok -- return
)


/*  ====================================================================================================
    SECTION 09: COMPATIBILITY HELPERS
    ====================================================================================================
*/


/*  Creates saved menu data from test source dictionary.
    Compatibility helper for old createSavedTestMenuDataLevel calls.
*/
function createSavedTestMenuDataLevel level_index menu_title:"" item_count:2 submenu_count:1 nested_level_count:1 macro_counter:#(0) macro_category:"_TEST_CATEGORY" minimum_submenu_item_count:1 =
(
	source_menu_items = createTestMacroDictionaryLevel \
		level_index \
		item_count:item_count \
		submenu_count:submenu_count \
		nested_level_count:nested_level_count \
		macro_counter:macro_counter \
		macro_category:macro_category \
		minimum_submenu_item_count:minimum_submenu_item_count

	menu_definition = MenuDefinition_v \
		type:#menu \
		title:menu_title \
		data:source_menu_items

	menu_build_manager = MenuBuildManager_v menus_data:#(menu_definition)

	saved_menus_data = menu_build_manager.buildSavedMenusData()
	menu_data = undefined

	if saved_menus_data.count > 0 then
	(
		menu_data = saved_menus_data[1]
	)

	menu_data -- return
)


/*  ====================================================================================================
    SECTION 10: TESTS
    ====================================================================================================
*/


/*  Tests normal menu definition.
    Creates public MenuDefinition_v with addItem and addMenu.
*/
function createTestMenuDefinition =
(
	menu_definition = MenuDefinition_v \
		type:#menu \
		title:"_MENU_REBUILDER_TEST_MENU"

	menu_definition.addItem "_TEST_CATEGORY" "_TEST_MACRO_1" title:"Menu Item 1"
	menu_definition.addItem "_TEST_CATEGORY" "_TEST_MACRO_2" title:"Menu Item 2"

	submenu_definition = menu_definition.addMenu "Submenu 1"
	submenu_definition.addItem "_TEST_CATEGORY" "_TEST_MACRO_3" title:"Submenu Item 1"

	menu_definition -- return
)


/*  Tests quad menu definition.
    Quad definition data is array of MenuDefinition_v quadrants.
*/
function createTestQuadDefinition =
(
	quad_definition = MenuDefinition_v \
		type:#quad \
		title:"_MENU_REBUILDER_TEST_QUAD"
		--quad_modifier:#nonePressed \

	quad_definition.data = #()

	quad_top_right = quad_definition.addQuad "Top Right" position:#TopRight
	quad_top_right.addItem "_TEST_CATEGORY" "_TEST_MACRO_4" title:"Top Right Item"

	quad_top_left = quad_definition.addQuad "Top Left" position:#TopLeft
	quad_top_left.addItem "_TEST_CATEGORY" "_TEST_MACRO_5" title:"Top Left Item"

	quad_bottom_left = quad_definition.addQuad "Bottom Left" position:#BottomLeft
	quad_bottom_left.addItem "_TEST_CATEGORY" "_TEST_MACRO_6" title:"Bottom Left Item"

	quad_bottom_right = quad_definition.addQuad "Bottom Right" position:#BottomRight
	quad_bottom_right.addItem "_TEST_CATEGORY" "_TEST_MACRO_7" title:"Bottom Right Item"

	quad_definition -- return
)


/*  Tests mass menu build manager.
    Builds normal menu and quad menu together.
*/
function testMenuBuildManagerMass =
(
	global MenuBuildManager

	menu_definition = createTestMenuDefinition()
	quad_definition = createTestQuadDefinition()

	menus_data = #(menu_definition, quad_definition)

	MenuBuildManager = MenuBuildManager_v menus_data:menus_data

	saved_menus_data = MenuBuildManager.run()

	saved_menus_data -- return
)


/*  Tests generated dictionary menu and quad definitions.
    Uses createTestMacroDictionaryLevel for both.
*/
function testMenuBuildManagerGenerated =
(
	global MenuBuildManager

	test_macro_counter = #(0)

	simple_user_menu_data = createTestMacroDictionaryLevel \
		0 \
		item_count:2 \
		submenu_count:1 \
		nested_level_count:1 \
		macro_counter:test_macro_counter \
		macro_category:"_TEST_CATEGORY" \
		minimum_submenu_item_count:1

	test_macro_counter = #(0)

	simple_user_menu_data_quad = createTestMacroDictionaryLevel \
		0 \
		item_count:2 \
		submenu_count:1 \
		nested_level_count:1 \
		macro_counter:test_macro_counter \
		macro_category:"_TEST_CATEGORY" \
		minimum_submenu_item_count:1

	menu_definition = MenuDefinition_v \
		type:#menu \
		title:"_TEST_GENERATED_MENU" \
		data:simple_user_menu_data

	quad_definition = MenuDefinition_v \
		type:#quad \
		title:"_TEST_GENERATED_QUAD"

	--quad_definition.data = #()
	--
	--quad_top_right = quad_definition.addQuad "Top Right" position:#TopRight
	--quad_top_right.data = simple_user_menu_data_quad

	menus_data = #(menu_definition, quad_definition)

	MenuBuildManager = MenuBuildManager_v menus_data:menus_data

	saved_menus_data = MenuBuildManager.run()

	saved_menus_data -- return
)


/*  Tests rebuild from JSON file.
    Loads saved data and registers manager callbacks.
*/
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


/*  Tests adding separate tool menus into same JSON file.
    Each run merges into shared JSON.
*/
function testMenuBuildManagerMultipleTools =
(
	first_menu_definition = MenuDefinition_v \
		type:#menu \
		title:"_MENU_REBUILDER_TOOL_A_MENU"

	first_menu_definition.addItem "_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_1" title:"Tool A Item"

	first_manager = MenuBuildManager_v menus_data:#(first_menu_definition)
	first_manager.run()

	second_menu_definition = MenuDefinition_v \
		type:#menu \
		title:"_MENU_REBUILDER_TOOL_B_MENU"

	second_menu_definition.addItem "_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_2" title:"Tool B Item"

	second_manager = MenuBuildManager_v menus_data:#(second_menu_definition)
	saved_menus_data = second_manager.run()

	saved_menus_data -- return
)


/*  ====================================================================================================
    SECTION 11: MANUAL TEST CALLS
    ====================================================================================================

    saved_menus_data = testMenuBuildManagerMass()
    printSavedMenusData saved_menus_data

    saved_menus_data = testMenuBuildManagerGenerated()
    printSavedMenusData saved_menus_data

    saved_menus_data = testMenuBuildManagerFromJson()
    printSavedMenusData saved_menus_data

    saved_menus_data = testMenuBuildManagerMultipleTools()
    printSavedMenusData saved_menus_data

    openMenuBuildManagerJsonRollout()

    menu_manager = MenuBuildManager_v()
    menu_manager.clearJsonFile()


*/

    --saved_menus_data = testMenuBuildManagerMass()

    --openMenuBuildManagerJsonRollout()
	
    --saved_menus_data = testMenuBuildManagerGenerated()
    --openMenuBuildManagerJsonRollout()
    
    --menu_manager = MenuBuildManager_v()
    --menu_manager.clearJsonFile()
	
	
/*  ====================================================================================================
    	TEST INJECTION TO "Default Viewport Quad"
    ====================================================================================================*/

  -- Injects into existing Default Viewport Quad:
    saved_menus_data = testMenuBuildManagerDefaultQuadInject()

    ---- Creates custom Ctrl+Shift+RMB quad:
    --saved_menus_data = testMenuBuildManagerCustomModifierQuad()
    --
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
    --
