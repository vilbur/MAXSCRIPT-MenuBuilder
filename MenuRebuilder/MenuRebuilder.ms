/*
	MenuRebuilder_v
	Version: 0.24
	3ds Max: 2026
	Purpose:
		Rebuild menus and quad menus from MenuBuildManager_v saved data.
		Default quad targets are injected into existing CUI quad menus.
*/

global MenuRebuilder_qmnx_clear_guard
if MenuRebuilder_qmnx_clear_guard == undefined then MenuRebuilder_qmnx_clear_guard = false

global MenuRebuilder_v

struct MenuRebuilder_v
(
	version = 0.24,
	menu_data = Dictionary #name,
	skip_default_qmnx_clear = false,
	help_menu_id = "cee8f758-2199-411b-81e7-d3ff4a80d143",
	macro_action_table_id = 647394,


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


	function createGuidString =
	(
		guid_class = dotNetClass "System.Guid"
		guid_value = guid_class.NewGuid()
		guid_value.ToString() -- return
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


	function getMenuId =
	(
		menu_id = this.getMenuDataValue #id ""

		if menu_id == undefined then
		(
			menu_id = ""
		)

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


	/*
	Normalize quad modifier.
	Example: #shiftAndControlAndAltPressed -> #shiftAndAltAndControlPressed.
	*/
	function normalizeQuadModifier modifier_value =
	(
		/*
		Join array to string.
		Used after modifier tokens are sorted.
		*/
		function arrayToString arr delimeter:"" =
		(
			_string = ""

			for item in arr do
			(
				_string += item as string + delimeter
			)

			substring _string 1 (_string.count - delimeter.count) -- return
		)

		normalized_mod = undefined
		valid_mods = #("shift", "alt", "control", "none")
		modifier_string = toLower (modifier_value as string)

		if (matchPattern modifier_string pattern:"*pressed") then
		(
			modifier_string = substring modifier_string 1 ((findString modifier_string "pressed") - 1)
		)

		modifier_string = substituteString modifier_string "and" "-"
		mod_keys_valid = for mod_key in sort (filterString modifier_string "-") where findItem valid_mods mod_key > 0 collect mod_key
		mod_keys_count = mod_keys_valid.count

		if mod_keys_count > 0 then
		(
			normalized_key = if mod_keys_count > 1 then arrayToString mod_keys_valid else mod_keys_valid[1]

			normalized_mod = case normalized_key of
			(
				"altshift": #shiftAndAltPressed
				"altcontrol": #controlAndAltPressed
				"controlshift": #shiftAndControlPressed
				"altcontrolshift": #shiftAndAltAndControlPressed
				default: (normalized_key + "Pressed") as name
			)
		)

		normalized_mod -- return
	),


	/*
	Convert normalized quad modifier to MaxScript CUI API-safe enum.
	3-key right click modifier works with #shiftAndControlAndAltPressed in SetRightClickModifiers.
	*/
	function getQuadModifierApiValue modifier_value =
	(
		api_modifier = this.normalizeQuadModifier modifier_value

		if api_modifier == #shiftAndAltAndControlPressed then
		(
			api_modifier = #shiftAndControlAndAltPressed
		)

		api_modifier -- return
	),


	function getQuadModifier =
	(
		this.getQuadModifierApiValue (this.getMenuDataValue #quad_modifier undefined) -- return
	),


	function getQuadPosition =
	(
		this.getMenuDataValue #quad_position #TopRight -- return
	),


	function getQuadMenuId =
	(
		quad_menu_id = this.getMenuDataValue #quad_menu_id ""

		if quad_menu_id == undefined then
		(
			quad_menu_id = ""
		)

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


	function getDefaultQuadTitle =
	(
		default_title = this.getMenuDataValue #default_quad_title ""

		if default_title == undefined then
		(
			default_title = ""
		)

		if default_title == "" then
		(
			default_title = this.getMenuTitle()
		)

		default_title -- return
	),


	function getIsDefaultQuad =
	(
		is_default = false

		if this.hasDictValueSafe this.menu_data #is_default_quad then
		(
			if this.menu_data[#is_default_quad] == true then
			(
				is_default = true
			)
		)

		is_default -- return
	),


	function trimString source_text =
	(
		trimmed_text = source_text as string
		start_index = 1
		end_index = trimmed_text.count

		while start_index <= end_index and findString " \t\r\n" (substring trimmed_text start_index 1) != undefined do
		(
			start_index += 1
		)

		while end_index >= start_index and findString " \t\r\n" (substring trimmed_text end_index 1) != undefined do
		(
			end_index -= 1
		)

		if end_index < start_index then
		(
			trimmed_text = ""
		)
		else
		(
			trimmed_text = substring trimmed_text start_index (end_index - start_index + 1)
		)

		trimmed_text -- return
	),


	function collapseWhitespace source_text =
	(
		clean_text = this.trimString (source_text as string)
		while findString clean_text "  " != undefined do
		(
			clean_text = substituteString clean_text "  " " "
		)
		clean_text -- return
	),


	function normalizeTitleForCompare source_text =
	(
		clean_text = source_text as string
		clean_text = substituteString clean_text "[" ""
		clean_text = substituteString clean_text "]" ""
		clean_text = this.collapseWhitespace clean_text
		clean_text -- return
	),


	function getShortQuadTitle source_text =
	(
		short_title = this.normalizeTitleForCompare source_text
		modifier_array = #( "Shift+Ctrl+Alt+RMB", "Shift+Ctrl+RMB", "Shift+Alt+RMB", "Ctrl+Alt+RMB", "Shift+RMB", "Alt+RMB", "Ctrl+RMB" )

		for modifier_text in modifier_array do
		(
			modifier_index = findString short_title modifier_text

			if modifier_index != undefined then
			(
				short_title = substring short_title 1 (modifier_index - 1)
				short_title = this.trimString short_title
			)
		)

		short_title -- return
	),


	function quadTitlesMatch title_a title_b =
	(
		was_match = false
		normal_a = this.normalizeTitleForCompare title_a
		normal_b = this.normalizeTitleForCompare title_b
		short_a = this.getShortQuadTitle title_a
		short_b = this.getShortQuadTitle title_b

		if normal_a == normal_b then
		(
			was_match = true
		)
		else if short_a == normal_b then
		(
			was_match = true
		)
		else if normal_a == short_b then
		(
			was_match = true
		)
		else if short_a == short_b then
		(
			was_match = true
		)

		was_match -- return
	),


	function isSeparatorItemData item_data =
	(
		is_separator = false

		if item_data == #SEPARATOR then
		(
			is_separator = true
		)
		else if this.isDictionaryValue item_data then
		(
			if this.hasDictValueSafe item_data #separator then
			(
				if item_data[#separator] == true then
				(
					is_separator = true
				)
			)

			if this.hasDictValueSafe item_data #type then
			(
				if item_data[#type] == #SEPARATOR then
				(
					is_separator = true
				)
			)

			if this.hasDictValueSafe item_data #title then
			(
				if item_data[#title] == #SEPARATOR then
				(
					is_separator = true
				)
			)
		)

		is_separator -- return
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


	function getSeparatorItemId item_data fallback_id =
	(
		this.getMenuItemBuildId item_data fallback_id -- return
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
		macro_category = ""
		macro_name = ""

		if this.isDictionaryValue item_data then
		(
			if this.hasDictValueSafe item_data #category then
			(
				macro_category = item_data[#category]
			)

			if this.hasDictValueSafe item_data #macro then
			(
				macro_name = item_data[#macro]
			)

			if macro_category != undefined and macro_name != undefined then
			(
				if (macro_category as string) != "" and (macro_name as string) != "" then
				(
					was_found = true
				)
			)
		)

		was_found -- return
	),


	function getMacroActionId macro_category macro_name =
	(
		((macro_name as string) + "`" + (macro_category as string)) -- return
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

		separator_item -- return
	),


	function createRealCuiAction parent_menu item_id macro_category macro_name =
	(
		created_item = undefined
		persistent_action_id = this.getMacroActionId macro_category macro_name

		if parent_menu != undefined then
		(
			try
			(
				created_item = parent_menu.CreateAction item_id this.macro_action_table_id persistent_action_id
			)
			catch
			(
				created_item = undefined
			)
		)

		created_item -- return
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
			submenu_menu = undefined

			try
			(
				submenu_menu = parent_menu.CreateSubMenu saved_guid submenu_title
			)
			catch
			(
				submenu_menu = undefined
			)

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
			created_item = this.createRealCuiAction parent_menu saved_guid macro_category macro_name
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

		if this.isArrayValue saved_items then
		(
			for item_index = 1 to saved_items.count do
			(
				item_data = saved_items[item_index]
				fallback_id = this.getMenuItemBuildId item_data (this.createGuidString())
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


	function getMainMenuBar menu_manager =
	(
		main_menu_bar = undefined

		if menu_manager != undefined then
		(
			try
			(
				main_menu_bar = menu_manager.mainMenuBar
			)
			catch
			(
				main_menu_bar = undefined
			)

			if main_menu_bar == undefined then
			(
				try
				(
					main_menu_bar = menu_manager.GetMainMenuBar()
				)
				catch
				(
					main_menu_bar = undefined
				)
			)
		)

		main_menu_bar -- return
	),


	function deleteMainMenu main_menu_bar =
	(
		was_deleted = false
		menu_id = this.getMenuId()

		if main_menu_bar != undefined then
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
		build_ok = false

		if not this.hasValidMenuTitle() then
		(
			format "MenuRebuilder_v.rebuildAsMainMenu skipped. Missing menu title.\n"
		)
		else
		(
			main_menu_bar = this.getMainMenuBar menu_manager

			if main_menu_bar == undefined then
			(
				format "MenuRebuilder_v.rebuildAsMainMenu failed. Main menu bar is undefined.\n"
			)
			else
			(
				menu_id = this.getMenuId()
				menu_title = this.getMenuTitle()
				this.deleteMainMenu main_menu_bar
				root_menu = undefined

				try
				(
					root_menu = main_menu_bar.CreateSubMenu menu_id menu_title beforeId:this.help_menu_id
				)
				catch
				(
					try
					(
						root_menu = main_menu_bar.CreateSubMenu menu_id menu_title
					)
					catch
					(
						root_menu = undefined
					)
				)

				if root_menu != undefined then
				(
					this.rebuildMenuItems root_menu (this.getMenuItems())
					build_ok = true
				)
			)
		)

		build_ok -- return
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


	function getQuadMenuTitle quad_menu =
	(
		quad_title = ""

		if quad_menu != undefined then
		(
			try
			(
				quad_title = quad_menu.GetTitle()
			)
			catch
			(
				quad_title = ""
			)

			if quad_title == "" then
			(
				try
				(
					quad_title = quad_menu.title
				)
				catch
				(
					quad_title = ""
				)
			)
		)

		quad_title -- return
	),


	function getQuadManagerContexts quad_menu_manager =
	(
		context_array = #()

		if quad_menu_manager != undefined then
		(
			try
			(
				for context_value in (quad_menu_manager.GetContexts()) do
				(
					append context_array context_value
				)
			)
			catch
			(
				ok
			)

			viewport_context = this.getQuadContext quad_menu_manager

			if viewport_context != undefined then
			(
				if findItem context_array viewport_context == 0 then
				(
					append context_array viewport_context
				)
			)
		)

		context_array -- return
	),


	function findExistingQuadMenuByTitle quad_menu_manager requested_title =
	(
		found_quad_menu = undefined
		search_title = this.normalizeTitleForCompare requested_title
		search_short_title = this.getShortQuadTitle requested_title
		context_array = this.getQuadManagerContexts quad_menu_manager

		for quad_context in context_array while found_quad_menu == undefined do
		(
			quad_menu_array = #()

			try
			(
				for quad_menu in (quad_context.GetQuadMenus()) do
				(
					append quad_menu_array quad_menu
				)
			)
			catch
			(
				quad_menu_array = #()
			)

			for quad_menu in quad_menu_array while found_quad_menu == undefined do
			(
				quad_title = this.getQuadMenuTitle quad_menu
				normal_quad_title = this.normalizeTitleForCompare quad_title
				short_quad_title = this.getShortQuadTitle quad_title

				if normal_quad_title == search_title then
				(
					found_quad_menu = quad_menu
				)
				else if short_quad_title == search_short_title then
				(
					found_quad_menu = quad_menu
				)
			)
		)

		found_quad_menu -- return
	),


	function getExistingDefaultQuadMenu quad_menu_manager =
	(
		quad_menu = undefined
		quad_context = this.getQuadContext quad_menu_manager
		quad_modifier = this.getQuadModifier()

		if quad_context != undefined and quad_modifier != undefined then
		(
			try
			(
				quad_menu = quad_context.GetRightClickMenuByModifiers quad_modifier
			)
			catch
			(
				quad_menu = undefined
			)
		)

		if quad_menu == undefined then
		(
			quad_menu = this.findExistingQuadMenuByTitle quad_menu_manager (this.getDefaultQuadTitle())
		)

		if quad_menu == undefined then
		(
			quad_menu = this.findExistingQuadMenuByTitle quad_menu_manager (this.getMenuTitle())
		)

		quad_menu -- return
	),


	function createCustomQuadRootMenu quad_context =
	(
		quad_menu = undefined
		quad_modifier = this.getQuadModifier()

		if quad_context != undefined then
		(
			try
			(
				quad_menu = quad_context.CreateQuadMenu (this.getMenuId()) (this.getMenuTitle())

				if quad_menu != undefined and quad_modifier != undefined then
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


	function injectExistingQuadPositionMenu quad_menu quad_position_value quad_items_value =
	(
		quad_position_menu = undefined

		if quad_menu != undefined then
		(
			try
			(
				quad_position_menu = quad_menu.GetMenuByPos quad_position_value
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
				format "MenuRebuilder_v.injectExistingQuadPositionMenu failed. Quad position not found: %\n" quad_position_value
			)
		)

		quad_position_menu -- return
	),


	function rebuildAsCustomModifierQuad quad_menu_manager =
	(
		build_ok = false

		if quad_menu_manager != undefined then
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

				build_ok = true
			)
		)

		build_ok -- return
	),


	function injectAsExistingDefaultQuad quad_menu_manager =
	(
		build_ok = false

		if quad_menu_manager == undefined then
		(
			format "MenuRebuilder_v.injectAsExistingDefaultQuad failed. quad_menu_manager is undefined.\n"
		)
		else
		(
			quad_menu = this.getExistingDefaultQuadMenu quad_menu_manager
			quad_menus = this.getQuadMenus()

			if quad_menu == undefined then
			(
				format "MenuRebuilder_v.injectAsExistingDefaultQuad failed. Existing quad not found. title:'%' default_title:'%' modifier:%\n" (this.getMenuTitle()) (this.getDefaultQuadTitle()) (this.getQuadModifier())
			)
			else
			(
				if quad_menus.count > 0 then
				(
					for quad_data in quad_menus do
					(
						quad_position_value = quad_data[#quad_position]
						quad_items_value = quad_data[#items]
						this.injectExistingQuadPositionMenu quad_menu quad_position_value quad_items_value
					)
				)
				else
				(
					this.injectExistingQuadPositionMenu quad_menu (this.getQuadPosition()) (this.getMenuItems())
				)

				format "MenuRebuilder_v: injected menu '%' into existing default quad '%'.\n" (this.getMenuTitle()) (this.getDefaultQuadTitle())
				build_ok = true
			)
		)

		build_ok -- return
	),


	function rebuildAsQuadMenu quad_menu_manager =
	(
		build_ok = false

		if not this.hasValidMenuTitle() then
		(
			format "MenuRebuilder_v.rebuildAsQuadMenu skipped. Missing menu title.\n"
		)
		else if this.getIsDefaultQuad() then
		(
			build_ok = this.injectAsExistingDefaultQuad quad_menu_manager
		)
		else
		(
			build_ok = this.rebuildAsCustomModifierQuad quad_menu_manager
		)

		build_ok -- return
	),


	on create do
	(
		ok
	)
)
