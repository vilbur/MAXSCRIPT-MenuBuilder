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


/**
Minimal workflow scenario test for MenuBuildManager_v.
*/

function workflowGuid =
(
	((dotNetClass "System.Guid").NewGuid()).ToString()
)


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


function resetMenuLike menu_like =
(
	if classOf menu_like == Dictionary then
	(
		menu_like[#items] = Dictionary #string
	)
	else
	(
		try
		(
			menu_like.clearItems()
		)
		catch
		(
			menu_like.data = Dictionary #string

			try
			(
				menu_like._data = menu_like.data
			)
			catch
			(
				ok
			)
		)
	)

	menu_like -- return
)


function addItemToMenuLike menu_like category_name macro_name item_title =
(
	if classOf menu_like == Dictionary then
	(
		if not HasDictValue menu_like #items then
		(
			menu_like[#items] = Dictionary #string
		)

		item_data = Dictionary #name
		item_data[#title] = item_title
		item_data[#category] = category_name
		item_data[#macro] = macro_name

		menu_like[#items][workflowGuid()] = item_data
	)
	else
	(
		menu_like.addItem category_name macro_name title:item_title
	)

	menu_like -- return
)


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

	/* 1) Create menu1 with 3 action items. */
	menu_1 = MenuBuildManager.menu "_WORKFLOW_MENU_1" type:#menu
	resetMenuLike menu_1

	addItemToMenuLike menu_1 category_name macro_1 "Menu1 Item 1"
	addItemToMenuLike menu_1 category_name macro_2 "Menu1 Item 2"
	addItemToMenuLike menu_1 category_name macro_3 "Menu1 Item 3"

	/* 2) Create menu2 with 2 items. Second item is submenu with submenu item. */
	menu_2 = MenuBuildManager.menu "_WORKFLOW_MENU_2" type:#menu
	resetMenuLike menu_2

	addItemToMenuLike menu_2 category_name macro_4 "Menu2 Item 1"

	menu_2_submenu = menu_2.addMenu "Menu2 Submenu"
	resetMenuLike menu_2_submenu
	addItemToMenuLike menu_2_submenu category_name macro_5 "Menu2 Submenu Item 1"

	/* 3) Create custom quad on CTRL+SHIFT. */
	custom_quad = MenuBuildManager.getQuad "_WORKFLOW_CUSTOM_QUAD" clear_default_menu:false
	custom_quad.quad_modifier = #shiftAndControlPressed

	/* 3A) First quad is flattened menu1. */
	custom_quad_1 = custom_quad.getQuad 1
	resetMenuLike custom_quad_1
	custom_quad_1.addMenu "_WORKFLOW_MENU_1" flat:true

	/* 3B) Second quad is custom item and menu2. */
	custom_quad_2 = custom_quad.getQuad 2
	resetMenuLike custom_quad_2
	addItemToMenuLike custom_quad_2 category_name macro_6 "Custom Quad Item"
	custom_quad_2.addMenu "_WORKFLOW_MENU_2"

	/* 4) Get Default Viewport Quad. */
	default_quad = MenuBuildManager.getQuad "Default Viewport Quad" clear_default_menu:true
	default_quad.quad_modifier = #nonePressed

	/* 4A) Add custom item to first quad. */
	default_quad_1 = default_quad.getQuad 1
	addItemToMenuLike default_quad_1 category_name macro_7 "Default Quad Added Item"

	/* 4B) Clear second quad and add menu1. */
	default_quad_2 = default_quad.getQuad 2
	resetMenuLike default_quad_2
	default_quad_2.addMenu "_WORKFLOW_MENU_1"

	/* 4C) Replace third quad with menu2. */
	default_quad_3 = default_quad.getQuad 3
	resetMenuLike default_quad_3
	default_quad_3.addMenu "_WORKFLOW_MENU_2"

	MenuBuildManager.waitForBuild menu_1
	MenuBuildManager.waitForBuild menu_2
	MenuBuildManager.waitForBuild custom_quad
	MenuBuildManager.waitForBuild default_quad

	saved_menus_data = MenuBuildManager.build()

	format "\nWORKFLOW TEST RESULT\n"
	format "Menu 1: _WORKFLOW_MENU_1 / 3 action items.\n"
	format "Menu 2: _WORKFLOW_MENU_2 / item + submenu item.\n"
	format "Custom Quad: _WORKFLOW_CUSTOM_QUAD / #shiftAndControlPressed.\n"
	format "Default Viewport Quad modified.\n"
	format "Saved menu data count: %\n" saved_menus_data.count

	saved_menus_data -- return
)


workflow_test_result = runMenuBuilderWorkflowScenarioTest()