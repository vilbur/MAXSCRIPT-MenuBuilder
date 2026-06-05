filein( getFilenamePath(getSourceFileName()) + "/../MenuBuildManager/MenuBuildManager.ms" )	--"./../MenuBuildManager/MenuBuildManager.ms"

/*
	MenuBuilder Default Viewport Quad Scenario Test
	Version: 0.01
	3ds Max 2026 / MenuBuildManager_v OOP workflow.

	Scenario:
	1) Quad 1: add item and menu.
	2) Quad 2: add item and flat menu.
	3) Quad 3: clear quad, then add item and menu.
	4) Quad 4: replace whole quad with flattened menu.
*/

global MenuBuildManager

struct MenuBuilder_DefaultViewportQuad_ScenarioTest_v
(
	version = 0.01,
	category_name = "_MENU_BUILDER_QUAD_SCENARIO_TEST",
	menu_prefix = "_QUAD_SCENARIO_MENU_",
	macro_prefix = "_QUAD_SCENARIO_MACRO_",


	function makeMacroName macro_index =
	(
		macro_name = this.macro_prefix + (macro_index as string)

		macro_name -- return
	),


	function makeMenuTitle menu_index =
	(
		menu_title = this.menu_prefix + (menu_index as string)

		menu_title -- return
	),


	function createTestMacro macro_index macro_title =
	(
		macro_name = this.makeMacroName macro_index
		macro_text = ""
		macro_text += "macroScript " + macro_name + "\n"
		macro_text += "category:\"" + this.category_name + "\"\n"
		macro_text += "toolTip:\"" + macro_title + "\"\n"
		macro_text += "buttonText:\"" + macro_title + "\"\n"
		macro_text += "(\n"
		macro_text += "\ton execute do\n"
		macro_text += "\t(\n"
		macro_text += "\t\tformat \"Executed: " + macro_title + "\\n\"\n"
		macro_text += "\t)\n"
		macro_text += ")\n"

		execute macro_text

		macro_name -- return
	),


	function createTestMacros =
	(
		for macro_index = 1 to 16 do
		(
			macro_title = "Macro " + (macro_index as string)
			this.createTestMacro macro_index macro_title
		)

		ok -- return
	),


	function getMainMacroIndex menu_index =
	(
		macro_index = ((menu_index - 1) * 3) + 1

		macro_index -- return
	),


	function getSubMenuMacroIndex menu_index =
	(
		macro_index = ((menu_index - 1) * 3) + 2

		macro_index -- return
	),


	function getQuadItemMacroIndex quad_index =
	(
		macro_index = 12 + quad_index

		macro_index -- return
	),


	function createWorkflowMenu menu_index =
	(
		menu_title = this.makeMenuTitle menu_index
		menu_definition = MenuBuildManager.menu menu_title
		menu_definition.clearItems()

		main_macro_index = this.getMainMacroIndex menu_index
		submenu_macro_index = this.getSubMenuMacroIndex menu_index

		menu_definition.addItem this.category_name (this.makeMacroName main_macro_index) title:("Menu " + (menu_index as string) + " A Item")
		menu_definition.addItem this.category_name (this.makeMacroName main_macro_index) title:("Menu " + (menu_index as string) + " B Item")

		submenu_definition = menu_definition.menu ("Menu " + (menu_index as string) + " Submenu")
		submenu_definition.addSeparator()
		submenu_definition.clearItems()
		submenu_definition.addSeparator()
		submenu_definition.addItem this.category_name (this.makeMacroName submenu_macro_index) title:("Menu " + (menu_index as string) + " Submenu Item")

		menu_definition -- return
	),


	function createWorkflowMenus =
	(
		workflow_menus = #()

		for menu_index = 1 to 4 do
		(
			append workflow_menus (this.createWorkflowMenu menu_index)
		)

		workflow_menus -- return
	),


	function resetMenuDefinitionItems menu_definition =
	(
		if menu_definition != undefined then
		(
			menu_definition.clearItems()
		)

		menu_definition -- return
	),


	function setupDefaultViewportQuad =
	(
		default_quad = MenuBuildManager.getQuad "Default Viewport Quad" clear_default_menu:true
		default_quad.quad_modifier = #nonePressed

		/*
		Quad index == menu index.
		Quad order:
		1 = #BottomRight
		2 = #TopRight
		3 = #TopLeft
		4 = #BottomLeft
		*/

		/* 1) To quad 1 add item and menu. */
		quad_1 = default_quad.getQuad 1
		quad_1.addItem this.category_name "Test_macro_1" title:"Quad 1 Direct Item 1"
		quad_1.addSeparator()
		quad_1.addItem this.category_name "Test_macro_1" title:"Quad 1 Direct Item 2"
		--quad_1.addMenu (this.makeMenuTitle 1)

		/* 2) To quad 2 add item and flat menu. */
		quad_2 = default_quad.getQuad 2

		quad_2.addSeparator()
		quad_2.addItem this.category_name "Test_macro_1" title:"Quad 2 Direct Item"
		quad_2.addMenu (this.makeMenuTitle 2) flat:true

		/* 3) Clear quad 3 and add item and menu. */
		quad_3 = default_quad.getQuad 3
		this.resetMenuDefinitionItems quad_3
		
		quad_3.addItem this.category_name "Test_macro_1" title:"Quad 3 Direct Item After Clear"
		quad_3.addMenu (this.makeMenuTitle 3)

		/* 4) Replace whole quad 4 with flattened menu. */
		quad_4 = default_quad.getQuad 4
		this.resetMenuDefinitionItems quad_4
		quad_4.addMenu (this.makeMenuTitle 4) --flat:true
		--quad_4.addMenu ((this.makeMenuTitle 4) + " XXX") flat:true

		default_quad -- return
	),


	function run compile_mode:#PRODUCTION install_now:true =
	(
		this.createTestMacros()

		MenuBuildManager = MenuBuildManager_v compile_mode:compile_mode merge_existing_data:true

		workflow_menus = this.createWorkflowMenus()
		default_quad = this.setupDefaultViewportQuad()

		--if install_now then
		--(
			MenuBuildManager.installMenusNow()
		--)
		--else
		--(
		--	MenuBuildManager.build()
		--)

		format "\nDefault Viewport Quad Scenario Test finished.\n"
		format "Created menus: %\n" workflow_menus.count
		format "Default quad title: %\n" default_quad.title

		MenuBuildManager.saved_menus_data -- return
	)
)

quad_scenario_test = MenuBuilder_DefaultViewportQuad_ScenarioTest_v()
quad_scenario_test.run install_now:true --compile_mode:#JSON 
