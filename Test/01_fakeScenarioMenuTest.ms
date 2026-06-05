 clearListener(); print("Cleared in: "+getSourceFileName())

global menu_rebuilder_file_version = 0.09
global MenuRebuilder
global MenuBuildManager

/* IMPORT HELPERS */ 
filein( getFilenamePath(getSourceFileName()) + "/Lib/printHelpers.ms" )	--"./Lib/printHelpers.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/createSavedTestMenuDataLevel.ms" )	--"./Lib/createSavedTestMenuDataLevel.ms"


/* PRODUCTION */
print "\n\n----- PRODUCTION TEST\n\n";filein( getFilenamePath(getSourceFileName()) + "/../MenuBuildManager/MenuBuildManager.ms" )	--"./../MenuBuildManager/MenuBuildManager.ms"

/* DEVELOPEMNT */ 
--print "\n\n----- !!!!! TEST MenuRebuilder_update.ms\n\n";filein( getFilenamePath(getSourceFileName()) + "/../MenuRebuilder_update.ms" )	--"./../MenuRebuilder_update.ms"



/**
Create GUID string for ordered test items.
*/
function createWorkflowGuidString =
(
	guid_class = dotNetClass "System.Guid"
	guid_value = guid_class.NewGuid()

	guid_value.ToString() -- return
)


/**
Ensure Dictionary submenu uses ordered item array.
*/
function ensureOrderedItemsOnDictionary menu_item =
(
	if not HasDictValue menu_item #items then
	(
		menu_item[#items] = #()
	)
	else if classOf menu_item[#items] != Array then
	(
		menu_item[#items] = #()
	)

	menu_item[#items] -- return
)


/**
Create ordered macro item.
Item id is stored inside item object.
*/
function createOrderedMacroItem category_name macro_name item_title =
(
	item_data = Dictionary #name

	item_data[#id] = createWorkflowGuidString()
	item_data[#title] = item_title
	item_data[#category] = category_name
	item_data[#macro] = macro_name

	item_data -- return
)


/**
Add action item to MenuDefinition_v or ordered Dictionary submenu.
*/
function addItemToMenuLike menu category_name macro_name item_title =
(
	if classOf menu == Dictionary then
	(
		items_array = ensureOrderedItemsOnDictionary menu
		append items_array (createOrderedMacroItem category_name macro_name item_title)
	)
	else
	(
		menu.addItem category_name macro_name title:item_title
	)

	menu -- return
)
/**
Create mock macroScript.
Used by workflow test.
*/
function createWorkflowTestMacro macro_index category_name:"_MENU_WORKFLOW_TEST" =
(
	macro_name = "_WORKFLOW_TEST_MACRO_" + (macro_index as string)
	macro_title = "Workflow Test Macro " + (macro_index as string)

	macro_text = ""
	macro_text += "macroScript " + macro_name + "\n"
	macro_text += "category:\"" + category_name + "\"\n"
	macro_text += "toolTip:\"" + macro_title + "\"\n"
	macro_text += "(\n"
	macro_text += "\ton execute do\n"
	macro_text += "\t(\n"
	macro_text += "\t\tformat \"" + macro_title + " executed.\\n\"\n"
	macro_text += "\t)\n"
	macro_text += ")\n"

	execute macro_text

	macro_name -- return
)


/**
Clear MenuDefinition_v items or ordered Dictionary submenu items.
*/
function resetMenuDefinitionItems menu_definition =
(
	if classOf menu_definition == Dictionary then
	(
		menu_definition[#items] = #()
	)
	else
	(
		try
		(
			menu_definition.clearItems()
		)
		catch
		(
			menu_definition.data = #()

			try
			(
				menu_definition._data = menu_definition.data
			)
			catch
			(
				ok
			)
		)
	)

	menu_definition -- return
)




/**
Run minimal real workflow test.
Creates 2 menus, 1 custom quad, and modifies Default Viewport Quad.
*/
function runMenuBuilderWorkflowScenarioTest =
(
	global MenuBuildManager

	category_name = "_MENU_WORKFLOW_TEST"

	macro_1 = createWorkflowTestMacro 1 category_name:category_name
	macro_2 = createWorkflowTestMacro 2 category_name:category_name
	macro_3 = createWorkflowTestMacro 3 category_name:category_name
	macro_4 = createWorkflowTestMacro 4 category_name:category_name
	macro_5 = createWorkflowTestMacro 5 category_name:category_name
	macro_6 = createWorkflowTestMacro 6 category_name:category_name
	macro_7 = createWorkflowTestMacro 7 category_name:category_name
	macro_8 = createWorkflowTestMacro 8 category_name:category_name

	MenuBuildManager = MenuBuildManager_v()

	/*  1) Create menu1 with 3 action items.
	*/
	menu_1 = MenuBuildManager.menu "_WORKFLOW_MENU_1" type:#menu
	resetMenuDefinitionItems menu_1

	menu_1.addItem category_name macro_1 title:"Menu1 Item 1"
	menu_1.addItem category_name macro_2 title:"Menu1 Item 2"
	menu_1.addItem category_name macro_3 title:"Menu1 Item 3"
		
--menu_1 = MenuBuildManager.menu "_OOP_MENU_1"
--menu_1.addItem category macro title:"Item"
--

	/*  2) Create menu2 with 2 items. Second item is submenu with submenu item.
	*/
	menu_2 = MenuBuildManager.menu "_WORKFLOW_MENU_2" type:#menu
	resetMenuDefinitionItems menu_2
	
	menu_2.addItem category_name macro_4 title:"Menu2 Item 1"
	
	menu_2_submenu = menu_2.menu "Submenu"
	menu_2_submenu.addItem category macro title:"Submenu Item"
	
	resetMenuDefinitionItems menu_2_submenu
	addItemToMenuLike menu_2_submenu category_name macro_5 "Menu2 Submenu Item 1"

	
	menu_3 = MenuBuildManager.menu "_WORKFLOW_MENU_3" type:#menu

	/*  3) Create new custom quad on CTRL+SHIFT.
		Quad 1: flattened menu1.
		Quad 2: custom item + menu2.
	*/
	custom_quad = MenuBuildManager.getQuad "_WORKFLOW_CUSTOM_QUAD" clear_default_menu:false
	custom_quad.quad_modifier = #shiftAndControlPressed
	
	custom_quad_1 = custom_quad.getQuad 1
	resetMenuDefinitionItems custom_quad_1
	custom_quad_1.addMenu "_WORKFLOW_MENU_1" flat:true
	
	custom_quad_2 = custom_quad.getQuad 2
	resetMenuDefinitionItems custom_quad_2
	custom_quad_2.addItem category_name macro_6 title:"Custom Quad Item"
	custom_quad_2.addMenu "_WORKFLOW_MENU_2"
	
	


	
	/*  4) Get Default Viewport Quad.
		Quad 1: add custom item.
		Quad 2: clear and add menu1.
		Quad 3: replace with menu2.
	*/
	default_quad = MenuBuildManager.getQuad "Default Viewport Quad" clear_default_menu:true
	default_quad.quad_modifier = #nonePressed
	
	/* ITEM IS ADDED OK */ 
	default_quad_1 = default_quad.getQuad 1
	default_quad_1.addItem category_name macro_1 title:"Default Quad Added Item"
	
	default_quad_2 = default_quad.getQuad 2
	resetMenuDefinitionItems default_quad_2
	default_quad_2.addItem category_name macro_2 title:"Default Quad Added Item"
	/* MENU IS ADDED BUT NOT SHOWN IN MENU */ 
	default_quad_2.addMenu "_WORKFLOW_MENU_2"
	
	default_quad_3 = default_quad.getQuad 3
	resetMenuDefinitionItems default_quad_3
	/* MENU IS ADDED BUT NOT SHOWN IN MENU */ 
	default_quad_3.addMenu "_WORKFLOW_MENU_3"
	
	/*  Save all menus and quads.
	*/
	MenuBuildManager.waitForBuild menu_1
	MenuBuildManager.waitForBuild menu_2
	MenuBuildManager.waitForBuild menu_3
	MenuBuildManager.waitForBuild custom_quad
	MenuBuildManager.waitForBuild default_quad
	
	saved_menus_data = MenuBuildManager.build()
	
	format "\nWORKFLOW TEST RESULT\n"
	format "1) Menu created: _WORKFLOW_MENU_1 with 3 items.\n"
	format "2) Menu created: _WORKFLOW_MENU_2 with item + submenu.\n"
	format "3) Custom quad created: _WORKFLOW_CUSTOM_QUAD on #shiftAndControlPressed.\n"
	format "4) Default Viewport Quad modified.\n"
	format "Saved menu data count: %\n" saved_menus_data.count

	saved_menus_data -- return
)


workflow_test_result = runMenuBuilderWorkflowScenarioTest()