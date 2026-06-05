
struct MenuRebuilder_v
(
	version = 0.18,
	menu_data = Dictionary #name,
	skip_default_qmnx_clear = false,
	help_menu_id = "cee8f758-2199-411b-81e7-d3ff4a80d143",
	macro_action_table_id = 647394,

	/*
	Real separator support for 3ds Max 2026 persistent CUI menus/quads.
	Separator must be created through ICuiMenu.CreateSeparator().
	*/
	function isSeparatorItemData item_data =
	(
		is_separator = false

		if item_data == #SEPARATOR then
		(
			is_separator = true
		)
		else
		(
			if classOf item_data == Dictionary then
			(
				try
				(
					if HasDictValue item_data #separator then
					(
						if item_data[#separator] == true then
						(
							is_separator = true
						)
					)

					if HasDictValue item_data #type then
					(
						if item_data[#type] == #SEPARATOR then
						(
							is_separator = true
						)
					)

					if HasDictValue item_data #title then
					(
						if item_data[#title] == #SEPARATOR then
						(
							is_separator = true
						)
					)
				)
				catch
				(
					is_separator = false
				)
			)
		)

		is_separator -- return
	),


	function getSeparatorItemId item_data fallback_id =
	(
		item_id = fallback_id

		if classOf item_data == Dictionary then
		(
			try
			(
				if HasDictValue item_data #id then
				(
					item_id = item_data[#id]
				)
			)
			catch
			(
				item_id = fallback_id
			)
		)

		if item_id == undefined then
		(
			item_id = this.createGuidString()
		)

		if item_id == "" then
		(
			item_id = this.createGuidString()
		)

		item_id -- return
	),


	function createRealCuiSeparator target_menu item_id =
	(
		separator_item = undefined

		if target_menu != undefined then
		(
			try
			(
				separator_item = target_menu.CreateSeparator item_id
			)
			catch
			(
				separator_item = undefined
			)
		)

		if separator_item == undefined then
		(
			format "MenuRebuilder_v.createRealCuiSeparator failed. item_id:%\n" item_id
		)

		separator_item -- return
	),



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


	function isArrayValue value =
	(
		was_array = false

		if value != undefined then
		(
			if classOf value == Array then
			(
				was_array = true
			)
		)

		was_array -- return
	),


	function createGuidString =
	(
		guid_class = dotNetClass "System.Guid"
		guid_value = guid_class.NewGuid()

		guid_value.ToString() -- return
	),


	function hasDictValueSafe dictionary_value dictionary_key =
	(
		was_found = false

		if this.isDictionaryValue dictionary_value then
		(
			try
			(
				was_found = HasDictValue dictionary_value dictionary_key
			)
			catch
			(
				was_found = false
			)
		)

		was_found -- return
	),


	function getMenuDataValue dictionary_key default_value =
	(
		value = default_value

		if this.hasDictValueSafe this.menu_data dictionary_key then
		(
			value = this.menu_data[dictionary_key]
		)

		value -- return
	),


	function normalizeQuadModifier modifier_value =
	(
		normalized_modifier = undefined
		modifier_text = ""

		if modifier_value != undefined then
		(
			modifier_text = modifier_value as string
		)

		if modifier_text == "#nonePressed" then normalized_modifier = #nonePressed
		if modifier_text == "nonePressed" then normalized_modifier = #nonePressed
		if modifier_text == "#nonePresses" then normalized_modifier = #nonePressed
		if modifier_text == "nonePresses" then normalized_modifier = #nonePressed

		if modifier_text == "#shiftPressed" then normalized_modifier = #shiftPressed
		if modifier_text == "shiftPressed" then normalized_modifier = #shiftPressed

		if modifier_text == "#controlPressed" then normalized_modifier = #controlPressed
		if modifier_text == "controlPressed" then normalized_modifier = #controlPressed

		if modifier_text == "#altPressed" then normalized_modifier = #altPressed
		if modifier_text == "altPressed" then normalized_modifier = #altPressed

		if modifier_text == "#shiftAndControlPressed" then normalized_modifier = #shiftAndControlPressed
		if modifier_text == "shiftAndControlPressed" then normalized_modifier = #shiftAndControlPressed

		normalized_modifier -- return
	),


	function getMenuId =
	(
		menu_id = this.getMenuDataValue #id ""

		if menu_id == "" then
		(
			menu_id = this.createGuidString()
			this.menu_data[#id] = menu_id
		)

		menu_id -- return
	),


	function getMenuTitle =
	(
		this.getMenuDataValue #title "" -- return
	),


	function hasValidMenuTitle =
	(
		menu_title = this.getMenuTitle()

		menu_title != "" -- return
	),


	function getMenuItems =
	(
		menu_items = this.getMenuDataValue #items #()

		if not (this.isArrayValue menu_items) then
		(
			if not (this.isDictionaryValue menu_items) then
			(
				menu_items = #()
			)
		)

		menu_items -- return
	),


	function getQuadContextId =
	(
		this.getMenuDataValue #quad_context_id "ac7c70f8-3f86-4ff5-a510-e4fd6a9c368e" -- return
	),


	function getQuadModifier =
	(
		this.normalizeQuadModifier (this.getMenuDataValue #quad_modifier undefined) -- return
	),


	function getQuadPosition =
	(
		this.getMenuDataValue #quad_position #TopRight -- return
	),


	function getQuadMenuId =
	(
		quad_menu_id = this.getMenuDataValue #quad_menu_id ""

		if quad_menu_id == "" then
		(
			quad_menu_id = this.createGuidString()
			this.menu_data[#quad_menu_id] = quad_menu_id
		)

		quad_menu_id -- return
	),


	function getQuadMenus =
	(
		quad_menus = this.getMenuDataValue #quad_menus #()

		if not this.isArrayValue quad_menus then
		(
			quad_menus = #()
		)

		quad_menus -- return
	),


	function getQmnxClearDirectory =
	(
		this.getMenuDataValue #qmnx_clear_directory "" -- return
	),


	function isDefaultQuadInjectionMode =
	(
		this.getQuadModifier() == #nonePressed -- return
	),


	function isSubMenuData item_data =
	(
		was_found = false

		if this.isDictionaryValue item_data then
		(
			was_found = this.hasDictValueSafe item_data #items
		)

		was_found -- return
	),


	function isMacroItemData item_data =
	(
		was_found = false

		if this.isDictionaryValue item_data then
		(
			if this.hasDictValueSafe item_data #category then
			(
				if this.hasDictValueSafe item_data #macro then
				(
					macro_category = item_data[#category]
					macro_name = item_data[#macro]

					if macro_category != undefined then
					(
						if macro_name != undefined then
						(
							if (macro_category as string) != "" then
							(
								if (macro_name as string) != "" then
								(
									was_found = true
								)
							)
						)
					)
				)
			)
		)

		was_found -- return
	),

	function getMacroActionId macro_category macro_name =
	(
		persistent_action_id = macro_name + "`" + macro_category

		persistent_action_id -- return
	),


	function getMenuItemBuildId item_data fallback_id =
	(
		item_id = fallback_id

		if this.isDictionaryValue item_data then
		(
			if this.hasDictValueSafe item_data #id then
			(
				item_id = item_data[#id]
			)
		)

		if item_id == undefined then
		(
			item_id = this.createGuidString()
		)

		if item_id == "" then
		(
			item_id = this.createGuidString()
		)

		item_id -- return
	),


	function rebuildSingleMenuItem parent_menu item_data fallback_id =
	(
		created_item = undefined
		saved_guid = this.getMenuItemBuildId item_data fallback_id

		if this.isSeparatorItemData item_data then
		(
			separator_id = this.getSeparatorItemId item_data saved_guid
			created_item = this.createRealCuiSeparator parent_menu separator_id
		)
		else if this.isSubMenuData item_data then
		(
			submenu_title = item_data[#title]
			submenu_items = item_data[#items]

			submenu_menu = parent_menu.CreateSubMenu saved_guid submenu_title
			created_item = submenu_menu

			if submenu_menu != undefined then
			(
				this.rebuildMenuItems submenu_menu submenu_items
			)
		)
		else if this.isMacroItemData item_data then
		(
			macro_category = item_data[#category]
			macro_name = item_data[#macro]
			persistent_action_id = this.getMacroActionId macro_category macro_name

			created_item = parent_menu.CreateAction saved_guid this.macro_action_table_id persistent_action_id
		)
		else
		(
			format "MenuRebuilder_v skipped invalid item data. id:% value:%\n" saved_guid item_data
		)

		created_item -- return
	),


	function rebuildMenuItems parent_menu saved_items =
	(
		build_ok = false

		if classOf saved_items == Array then
		(
			for item_index = 1 to saved_items.count do
			(
				item_data = saved_items[item_index]
				fallback_id = this.createGuidString()
				this.rebuildSingleMenuItem parent_menu item_data fallback_id
			)

			build_ok = true
		)
		else if this.isDictionaryValue saved_items then
		(
			saved_guid_array = GetDictKeys saved_items

			for saved_guid in saved_guid_array do
			(
				item_data = saved_items[saved_guid]
				this.rebuildSingleMenuItem parent_menu item_data saved_guid
			)

			build_ok = true
		)
		else
		(
			format "MenuRebuilder_v.rebuildMenuItems skipped. saved_items is not Array or Dictionary: %\n" saved_items
		)

		build_ok -- return
	),


	function deleteMainMenu main_menu_bar =
	(
		was_deleted = false
		menu_id = this.getMenuId()

		if menu_id != "" then
		(
			try
			(
				was_deleted = main_menu_bar.DeleteItem menu_id
			)
			catch
			(
				was_deleted = false
			)
		)

		was_deleted -- return
	),


	function rebuildAsMainMenu menu_manager =
	(
		if not this.hasValidMenuTitle() then
		(
			format "MenuRebuilder_v.rebuildAsMainMenu skipped. Missing menu title.\n"
			false -- return
		)
		else if menu_manager == undefined then
		(
			format "MenuRebuilder_v.rebuildAsMainMenu failed. menu_manager is undefined.\n"
			false -- return
		)
		else
		(
			main_menu_bar = menu_manager.mainMenuBar
			menu_id = this.getMenuId()
			menu_title = this.getMenuTitle()
			menu_items = this.getMenuItems()

			this.deleteMainMenu main_menu_bar

			root_menu = main_menu_bar.CreateSubMenu menu_id menu_title beforeId:this.help_menu_id

			if root_menu != undefined then
			(
				this.rebuildMenuItems root_menu menu_items
			)

			true -- return
		)
	),


	function getQuadContext quad_menu_manager =
	(
		quad_context = undefined

		if quad_menu_manager != undefined then
		(
			try
			(
				quad_context = quad_menu_manager.GetContextById (this.getQuadContextId())
			)
			catch
			(
				quad_context = undefined
			)
		)

		quad_context -- return
	),


	function createCustomQuadRootMenu quad_context =
	(
		quad_menu = undefined
		quad_modifier = this.getQuadModifier()

		if not this.hasValidMenuTitle() then
		(
			format "MenuRebuilder_v.createCustomQuadRootMenu skipped. Missing menu title.\n"
		)
		else if quad_modifier == undefined then
		(
			format "MenuRebuilder_v.createCustomQuadRootMenu skipped. quad_modifier is undefined.\n"
		)
		else if quad_context != undefined then
		(
			try
			(
				quad_menu = quad_context.CreateQuadMenu (this.getMenuId()) (this.getMenuTitle())

				if quad_menu != undefined then
				(
					quad_context.SetRightClickModifiers quad_menu quad_modifier
				)
			)
			catch
			(
				quad_menu = undefined
			)
		)

		quad_menu -- return
	),


	function getDefaultViewportQuadMenu quad_context =
	(
		default_quad = undefined

		if quad_context != undefined then
		(
			try
			(
				default_quad = quad_context.GetRightClickMenuByModifiers #nonePressed
			)
			catch
			(
				default_quad = undefined
			)
		)

		default_quad -- return
	),


	function rebuildCustomQuadPositionMenu quad_menu quad_title quad_position_value quad_menu_id_value quad_items_value =
	(
		quad_position_menu = undefined

		if quad_menu != undefined then
		(
			try
			(
				quad_position_menu = quad_menu.CreateMenu quad_menu_id_value quad_title quad_position_value
			)
			catch
			(
				quad_position_menu = undefined
			)

			if quad_position_menu != undefined then
			(
				this.rebuildMenuItems quad_position_menu quad_items_value
			)
		)

		quad_position_menu -- return
	),


	function injectDefaultQuadPositionMenu default_quad quad_position_value quad_items_value =
	(
		quad_position_menu = undefined

		if default_quad != undefined then
		(
			try
			(
				quad_position_menu = default_quad.GetMenuByPos quad_position_value
			)
			catch
			(
				quad_position_menu = undefined
			)

			if quad_position_menu != undefined then
			(
				this.rebuildMenuItems quad_position_menu quad_items_value
			)
			else
			(
				format "MenuRebuilder_v.injectDefaultQuadPositionMenu failed. Quad position not found: %\n" quad_position_value
			)
		)

		quad_position_menu -- return
	),


	function collectDefaultQuadClearPositions =
	(
		clear_positions = #()
		quad_menus = this.getQuadMenus()

		if quad_menus.count > 0 then
		(
			for quad_data in quad_menus do
			(
				if this.hasDictValueSafe quad_data #quad_position then
				(
					append clear_positions quad_data[#quad_position]
				)
			)
		)
		else
		(
			append clear_positions (this.getQuadPosition())
		)

		clear_positions -- return
	),


	function clearDefaultViewportQuadByQmnx =
	(
		was_loaded = false

		if this.isDefaultQuadInjectionMode() then
		(
			clear_positions = this.collectDefaultQuadClearPositions()

			qmnx_clear = QuadDefaultQmnxClear_v \
				qmnx_clear_directory:(this.getQmnxClearDirectory())

			was_loaded = qmnx_clear.clearPositions clear_positions
		)

		was_loaded -- return
	),


	function rebuildAsCustomModifierQuad quad_menu_manager =
	(
		if quad_menu_manager == undefined then
		(
			format "MenuRebuilder_v.rebuildAsCustomModifierQuad failed. quad_menu_manager is undefined.\n"
			false -- return
		)
		else
		(
			quad_context = this.getQuadContext quad_menu_manager
			quad_menu = this.createCustomQuadRootMenu quad_context
			quad_menus = this.getQuadMenus()

			if quad_menu != undefined then
			(
				if quad_menus.count > 0 then
				(
					for quad_data in quad_menus do
					(
						quad_title = quad_data[#title]
						quad_position_value = quad_data[#quad_position]
						quad_menu_id_value = quad_data[#quad_menu_id]
						quad_items_value = quad_data[#items]

						this.rebuildCustomQuadPositionMenu quad_menu quad_title quad_position_value quad_menu_id_value quad_items_value
					)
				)
				else
				(
					this.rebuildCustomQuadPositionMenu quad_menu (this.getMenuTitle()) (this.getQuadPosition()) (this.getQuadMenuId()) (this.getMenuItems())
				)
			)

			true -- return
		)
	),


	function injectAsDefaultViewportQuad quad_menu_manager =
	(
		if quad_menu_manager == undefined then
		(
			format "MenuRebuilder_v.injectAsDefaultViewportQuad failed. quad_menu_manager is undefined.\n"
			false -- return
		)
		else
		(
			if not this.skip_default_qmnx_clear then
			(
				this.clearDefaultViewportQuadByQmnx()
			)

			quad_context = this.getQuadContext quad_menu_manager
			default_quad = this.getDefaultViewportQuadMenu quad_context
			quad_menus = this.getQuadMenus()

			if default_quad == undefined then
			(
				format "MenuRebuilder_v.injectAsDefaultViewportQuad failed. Default viewport quad not found.\n"
				false -- return
			)
			else
			(
				if quad_menus.count > 0 then
				(
					for quad_data in quad_menus do
					(
						quad_position_value = quad_data[#quad_position]
						quad_items_value = quad_data[#items]

						this.injectDefaultQuadPositionMenu default_quad quad_position_value quad_items_value
					)
				)
				else
				(
					this.injectDefaultQuadPositionMenu default_quad (this.getQuadPosition()) (this.getMenuItems())
				)

				format "MenuRebuilder_v: injected menu '%' into Default Viewport Quad.\n" (this.getMenuTitle())

				true -- return
			)
		)
	),


	function rebuildAsQuadMenu quad_menu_manager =
	(
		if not this.hasValidMenuTitle() then
		(
			format "MenuRebuilder_v.rebuildAsQuadMenu skipped. Missing menu title.\n"
			false -- return
		)
		else if this.isDefaultQuadInjectionMode() then
		(
			this.injectAsDefaultViewportQuad quad_menu_manager -- return
		)
		else
		(
			this.rebuildAsCustomModifierQuad quad_menu_manager -- return
		)
	),


	on create do
	(
		ok
	)
)


