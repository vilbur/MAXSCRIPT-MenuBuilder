/*  Existing menu loader.
    Best-effort reader for existing CUI menus and quad menus.
*/
struct MenuLoader_v
(
	default_viewport_quad_title = "Default Viewport Quad",
	default_quad_context_id = "ac7c70f8-3f86-4ff5-a510-e4fd6a9c368e",


	/*  Checks if value is Dictionary.
	    Used before dictionary operations.
	*/
	function isDictionaryValue value =
	(
		was_dictionary = false

		if value != undefined then
		(
			if classOf value == Dictionary then
			(
				was_dictionary = true
			)
		)

		was_dictionary -- return
	),


	/*  Checks if string is known default viewport quad title.
	    This decides whether newMenu creates #quad definition.
	*/
	function isDefaultViewportQuadTitle menu_title =
	(
		menu_title == this.default_viewport_quad_title -- return
	),


	/*  Creates empty menu definition.
	    Used when existing menu cannot be read.
	*/
	function createEmptyMenuDefinition menu_title =
	(
		menu_definition = MenuDefinition_v \
			type:#menu \
			title:menu_title

		menu_definition -- return
	),


	/*  Creates empty quad definition.
	    Used when existing quad cannot be read.
	*/
	function createEmptyQuadDefinition menu_title =
	(
		menu_definition = MenuDefinition_v \
			type:#quad \
			title:menu_title \
			quad_context_id:this.default_quad_context_id

		menu_definition.data = #()

		menu_definition -- return
	),


	/*  Creates empty quad definition with four quadrant definitions.
	    This gives valid structure even when existing quad items cannot be read.
	*/
	function createEmptyViewportQuadDefinition menu_title =
	(
		menu_definition = this.createEmptyQuadDefinition menu_title

		menu_definition.addQuad "Top Left" position:#TopLeft
		menu_definition.addQuad "Top Right" position:#TopRight
		menu_definition.addQuad "Bottom Left" position:#BottomLeft
		menu_definition.addQuad "Bottom Right" position:#BottomRight

		menu_definition -- return
	),


	/*  Gets property value safely.
	    Returns default value when property does not exist.
	*/
	function getPropertySafe object_value property_name default_value =
	(
		result_value = default_value

		try
		(
			if isProperty object_value property_name then
			(
				result_value = getProperty object_value property_name
			)
		)
		catch
		(
			result_value = default_value
		)

		result_value -- return
	),


	/*  Calls no-argument method safely.
	    Returns default value when method does not exist or fails.
	*/
	function callMethodSafe object_value method_name default_value =
	(
		result_value = default_value

		try
		(
			method_value = getProperty object_value method_name
			result_value = method_value()
		)
		catch
		(
			result_value = default_value
		)

		result_value -- return
	),


	/*  Calls one-argument method safely.
	    Returns default value when method does not exist or fails.
	*/
	function callMethod1Safe object_value method_name argument_value default_value =
	(
		result_value = default_value

		try
		(
			method_value = getProperty object_value method_name
			result_value = method_value argument_value
		)
		catch
		(
			result_value = default_value
		)

		result_value -- return
	),


	/*  Gets possible menu item count.
	    Tries several possible CUI API names.
	*/
	function getMenuItemCount menu_value =
	(
		item_count = 0

		item_count = this.callMethodSafe menu_value #GetItemCount 0

		if item_count == 0 then
		(
			item_count = this.callMethodSafe menu_value #NumItems 0
		)

		if item_count == 0 then
		(
			item_count = this.getPropertySafe menu_value #numItems 0
		)

		if item_count == 0 then
		(
			item_count = this.getPropertySafe menu_value #count 0
		)

		item_count -- return
	),


	/*  Gets possible menu item by index.
	    Tries several possible CUI API names.
	*/
	function getMenuItemByIndex menu_value item_index =
	(
		item_value = undefined

		item_value = this.callMethod1Safe menu_value #GetItem item_index undefined

		if item_value == undefined then
		(
			item_value = this.callMethod1Safe menu_value #GetItemByIndex item_index undefined
		)

		if item_value == undefined then
		(
			try
			(
				item_value = menu_value[item_index]
			)
			catch
			(
				item_value = undefined
			)
		)

		item_value -- return
	),


	/*  Gets possible visible item title.
	    Returns empty string when title cannot be read.
	*/
	function getItemTitle item_value =
	(
		item_title = ""

		item_title = this.getPropertySafe item_value #title ""

		if item_title == "" then
		(
			item_title = this.getPropertySafe item_value #name ""
		)

		if item_title == "" then
		(
			item_title = this.callMethodSafe item_value #GetTitle ""
		)

		if item_title == "" then
		(
			item_title = this.callMethodSafe item_value #GetName ""
		)

		item_title -- return
	),


	/*  Gets possible action category.
	    Returns empty string when category cannot be read.
	*/
	function getItemCategory item_value =
	(
		item_category = ""

		item_category = this.getPropertySafe item_value #category ""

		if item_category == "" then
		(
			item_category = this.getPropertySafe item_value #macroCategory ""
		)

		if item_category == "" then
		(
			item_category = this.callMethodSafe item_value #GetCategory ""
		)

		if item_category == "" then
		(
			item_category = this.callMethodSafe item_value #GetMacroCategory ""
		)

		item_category -- return
	),


	/*  Gets possible action macro name.
	    Returns empty string when macro name cannot be read.
	*/
	function getItemMacroName item_value =
	(
		macro_name = ""

		macro_name = this.getPropertySafe item_value #macro ""

		if macro_name == "" then
		(
			macro_name = this.getPropertySafe item_value #macroName ""
		)

		if macro_name == "" then
		(
			macro_name = this.getPropertySafe item_value #actionId ""
		)

		if macro_name == "" then
		(
			macro_name = this.callMethodSafe item_value #GetMacro ""
		)

		if macro_name == "" then
		(
			macro_name = this.callMethodSafe item_value #GetMacroName ""
		)

		if macro_name == "" then
		(
			macro_name = this.callMethodSafe item_value #GetActionId ""
		)

		macro_name -- return
	),


	/*  Gets possible submenu object from item.
	    Returns undefined when item is not readable submenu.
	*/
	function getSubMenuFromItem item_value =
	(
		submenu_value = undefined

		submenu_value = this.getPropertySafe item_value #menu undefined

		if submenu_value == undefined then
		(
			submenu_value = this.getPropertySafe item_value #subMenu undefined
		)

		if submenu_value == undefined then
		(
			submenu_value = this.callMethodSafe item_value #GetMenu undefined
		)

		if submenu_value == undefined then
		(
			submenu_value = this.callMethodSafe item_value #GetSubMenu undefined
		)

		submenu_value -- return
	),


	/*  Checks if item looks like submenu.
	    Used by recursive loader.
	*/
	function isSubMenuItem item_value =
	(
		submenu_value = this.getSubMenuFromItem item_value

		submenu_value != undefined -- return
	),


	/*  Checks if item looks like macro action.
	    Needs category and macro name.
	*/
	function isMacroActionItem item_value =
	(
		item_category = this.getItemCategory item_value
		macro_name = this.getItemMacroName item_value

		item_category != "" and macro_name != "" -- return
	),


	/*  Loads readable CUI menu object into Dictionary #string.
	    Returns empty dictionary if item enumeration is not exposed by CUI API.
	*/
	function loadMenuObjectToDictionary menu_value =
	(
		menu_data = Dictionary #string

		if menu_value != undefined then
		(
			item_count = this.getMenuItemCount menu_value

			if item_count > 0 then
			(
				for item_index = 1 to item_count do
				(
					item_value = this.getMenuItemByIndex menu_value item_index

					if item_value != undefined then
					(
						item_title = this.getItemTitle item_value

						if item_title != "" then
						(
							if this.isSubMenuItem item_value then
							(
								submenu_value = this.getSubMenuFromItem item_value
								menu_data[item_title] = this.loadMenuObjectToDictionary submenu_value
							)
							else if this.isMacroActionItem item_value then
							(
								item_category = this.getItemCategory item_value
								macro_name = this.getItemMacroName item_value

								menu_data[item_title] = #(item_category, macro_name)
							)
						)
					)
				)
			)
		)

		menu_data -- return
	),


	/*  Finds existing normal menu by title.
	    Supports older menuMan.findMenu when available.
	*/
	function findExistingMenuByTitle menu_title =
	(
		menu_value = undefined

		try
		(
			menu_value = menuMan.findMenu menu_title
		)
		catch
		(
			menu_value = undefined
		)

		menu_value -- return
	),


	/*  Loads existing normal menu by title.
	    Returns MenuDefinition_v.
	*/
	function loadExistingMenu menu_title =
	(
		menu_definition = this.createEmptyMenuDefinition menu_title
		menu_value = this.findExistingMenuByTitle menu_title

		if menu_value != undefined then
		(
			menu_definition.data = this.loadMenuObjectToDictionary menu_value
		)

		menu_definition -- return
	),


	/*  Gets current quad menu manager if CUI exposes it.
	    Returns undefined when not available outside callback.
	*/
	function getQuadMenuManager =
	(
		quad_manager = undefined

		try
		(
			quad_manager = cui.getQuadMenuManager()
		)
		catch
		(
			quad_manager = undefined
		)

		if quad_manager == undefined then
		(
			try
			(
				quad_manager = quadMenuMan
			)
			catch
			(
				quad_manager = undefined
			)
		)

		quad_manager -- return
	),


	/*  Gets viewport quad context from quad manager.
	    Returns undefined when context cannot be found.
	*/
	function getViewportQuadContext quad_manager =
	(
		quad_context = undefined

		if quad_manager != undefined then
		(
			try
			(
				quad_context = quad_manager.GetContextById this.default_quad_context_id
			)
			catch
			(
				quad_context = undefined
			)
		)

		quad_context -- return
	),


	/*  Finds existing quad menu by title.
	    Uses several possible API names and fails safely.
	*/
	function findExistingQuadByTitle menu_title =
	(
		quad_menu = undefined
		quad_manager = this.getQuadMenuManager()
		quad_context = this.getViewportQuadContext quad_manager

		if quad_context != undefined then
		(
			quad_menu = this.callMethod1Safe quad_context #FindQuadMenu menu_title undefined

			if quad_menu == undefined then
			(
				quad_menu = this.callMethod1Safe quad_context #GetQuadMenuByName menu_title undefined
			)

			if quad_menu == undefined then
			(
				quad_menu = this.callMethod1Safe quad_context #GetQuadMenu menu_title undefined
			)
		)

		quad_menu -- return
	),


	/*  Gets readable quadrant menu from quad menu.
	    Tries possible CUI API names.
	*/
	function getQuadPositionMenu quad_menu quad_position =
	(
		position_menu = undefined

		if quad_menu != undefined then
		(
			position_menu = this.callMethod1Safe quad_menu #GetMenu quad_position undefined

			if position_menu == undefined then
			(
				position_menu = this.callMethod1Safe quad_menu #GetMenuByPosition quad_position undefined
			)

			if position_menu == undefined then
			(
				position_menu = this.getPropertySafe quad_menu quad_position undefined
			)
		)

		position_menu -- return
	),


	/*  Loads one quad quadrant from existing quad.
	    Returns MenuDefinition_v for quadrant.
	*/
	function loadExistingQuadPosition quad_menu quadrant_title quad_position =
	(
		quad_definition = MenuDefinition_v \
			type:#quad \
			title:quadrant_title \
			quad_position:quad_position \
			quad_context_id:this.default_quad_context_id

		position_menu = this.getQuadPositionMenu quad_menu quad_position

		if position_menu != undefined then
		(
			quad_definition.data = this.loadMenuObjectToDictionary position_menu
		)

		quad_definition -- return
	),


	/*  Loads existing quad menu by title.
	    Returns MenuDefinition_v with array of quadrant definitions.
	*/
	function loadExistingQuadMenu menu_title =
	(
		menu_definition = this.createEmptyQuadDefinition menu_title
		quad_menu = this.findExistingQuadByTitle menu_title

		menu_definition.data = #()

		append menu_definition.data (this.loadExistingQuadPosition quad_menu "Top Left" #TopLeft)
		append menu_definition.data (this.loadExistingQuadPosition quad_menu "Top Right" #TopRight)
		append menu_definition.data (this.loadExistingQuadPosition quad_menu "Bottom Left" #BottomLeft)
		append menu_definition.data (this.loadExistingQuadPosition quad_menu "Bottom Right" #BottomRight)

		menu_definition -- return
	),


	/*  Loads existing menu by title.
	    Default viewport quad title is loaded as quad menu.
	*/
	function loadExistingMenuByTitle menu_title =
	(
		if this.isDefaultViewportQuadTitle menu_title then
		(
			menu_definition = this.loadExistingQuadMenu menu_title
		)
		else
		(
			menu_definition = this.loadExistingMenu menu_title
		)

		menu_definition -- return
	),


	on create do
	(
		ok
	)
)