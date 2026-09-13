/*
	MenuDefinition_v
	Version: 0.97
	Purpose: Ordered menu definition with OOP-friendly submenu creation, ordered quads, title aliases, real separator items, and deferred menu reference resolving.
*/


struct MenuDefinition_v
(
	version = 0.97,
	type = #menu,
	title = "",
	data = undefined,
	_data = undefined,
	quad_modifier = undefined,
	quad_position = undefined,
	quad_context_id = "ac7c70f8-3f86-4ff5-a510-e4fd6a9c368e",
	manager = undefined,
	parent_item_data = undefined,
	last_added_item = undefined,
	qmnx_clear_directory = "",
	clear_default_menu = false,
	quad_order = #(#BottomRight, #TopRight, #TopLeft, #BottomLeft),


	/*
	Create guid string.
	Used for stable menu item ids.
	*/
	function createGuidString =
	(
		guid_class = dotNetClass "System.Guid"
		guid_value = guid_class.NewGuid()

		guid_value.ToString() -- return
	),


	/*
	Check Dictionary value.
	Used before HasDictValue access.
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


	/*
	Check Array value.
	Menu items are stored as ordered arrays.
	*/
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


	/*
	Check dictionary key safely.
	Prevents HasDictValue type errors.
	*/
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


	/*
	Get active ordered data array.
	_data is kept for old caller compatibility.
	*/
	function getActiveData =
	(
		active_data = this.data

		if this._data != undefined then
		(
			active_data = this._data
		)

		active_data -- return
	),


	/*
	Set active data array.
	If this is submenu definition, sync parent item #items too.
	*/
	function setActiveData value =
	(
		this.data = value
		this._data = value
		this.last_added_item = undefined

		if this.parent_item_data != undefined then
		(
			if this.isDictionaryValue this.parent_item_data then
			(
				this.parent_item_data[#items] = value
			)
		)

		value -- return
	),


	/*
	Ensure active item array exists.
	This is the ordered menu item storage.
	*/
	function ensureItemsArray =
	(
		active_data = this.getActiveData()

		if not (this.isArrayValue active_data) then
		(
			active_data = #()
			this.setActiveData active_data
		)

		active_data -- return
	),


	/*
	Normalize quad position.
	Accepts 1-4 or common position names.
	*/
	function normalizeQuadPosition quad_position_value =
	(
		normalized_position = #BottomRight

		if classOf quad_position_value == Integer then
		(
			case quad_position_value of
			(
				1: normalized_position = #BottomRight
				2: normalized_position = #TopRight
				3: normalized_position = #TopLeft
				4: normalized_position = #BottomLeft
				default: normalized_position = #BottomRight
			)
		)
		else
		(
			position_text = quad_position_value as string

			case position_text of
			(
				"#BottomRight": normalized_position = #BottomRight
				"#bottomRight": normalized_position = #BottomRight
				"BottomRight": normalized_position = #BottomRight
				"bottomRight": normalized_position = #BottomRight
				"bottom_right": normalized_position = #BottomRight
				"Bottom Right": normalized_position = #BottomRight

				"#TopRight": normalized_position = #TopRight
				"#topRight": normalized_position = #TopRight
				"TopRight": normalized_position = #TopRight
				"topRight": normalized_position = #TopRight
				"top_right": normalized_position = #TopRight
				"Top Right": normalized_position = #TopRight

				"#TopLeft": normalized_position = #TopLeft
				"#topLeft": normalized_position = #TopLeft
				"#TopeLeft": normalized_position = #TopLeft
				"#topeLeft": normalized_position = #TopLeft
				"TopLeft": normalized_position = #TopLeft
				"topLeft": normalized_position = #TopLeft
				"TopeLeft": normalized_position = #TopLeft
				"topeLeft": normalized_position = #TopLeft
				"top_left": normalized_position = #TopLeft
				"tope_left": normalized_position = #TopLeft
				"Top Left": normalized_position = #TopLeft

				"#BottomLeft": normalized_position = #BottomLeft
				"#bottomLeft": normalized_position = #BottomLeft
				"BottomLeft": normalized_position = #BottomLeft
				"bottomLeft": normalized_position = #BottomLeft
				"bottom_left": normalized_position = #BottomLeft
				"Bottom Left": normalized_position = #BottomLeft

				default: normalized_position = #BottomRight
			)
		)

		normalized_position -- return
	),

	/*
	Get quad title from position.
	Used when quad position is auto-created.
	*/
	function getQuadTitleFromPosition quad_position_value =
	(
		normalized_position = this.normalizeQuadPosition quad_position_value
		quad_title = "Bottom Right"

		case normalized_position of
		(
			#BottomRight: quad_title = "Bottom Right"
			#TopRight: quad_title = "Top Right"
			#TopLeft: quad_title = "Top Left"
			#BottomLeft: quad_title = "Bottom Left"
			default: quad_title = "Bottom Right"
		)

		quad_title -- return
	),

	/*
	Get canonical quad order index.
	Order: 1=#BottomRight, 2=#TopRight, 3=#TopLeft, 4=#BottomLeft.
	*/
	function getQuadOrderIndex quad_position_value =
	(
		normalized_position = this.normalizeQuadPosition quad_position_value
		order_index = findItem this.quad_order normalized_position

		if order_index == 0 then
		(
			order_index = 9999
		)

		order_index -- return
	),


	/*
	Reorder quad definitions to canonical quad order.
	*/
	function reorderQuadArray quad_array =
	(
		ordered_array = #()

		for ordered_position in this.quad_order do
		(
			for quad_definition in quad_array do
			(
				try
				(
					if quad_definition.quad_position == ordered_position then
					(
						append ordered_array quad_definition
					)
				)
				catch
				(
					ok
				)
			)
		)

		for quad_definition in quad_array do
		(
			if (findItem ordered_array quad_definition) == 0 then
			(
				append ordered_array quad_definition
			)
		)

		ordered_array -- return
	),


	/*
	Create macro item data.
	Item id is stored inside item object.
	*/
	function makeMacroItemData item_title macro_category macro_name custom_title:false id:undefined =
	(
		item_data = Dictionary #name
		item_id = id

		if item_id == undefined then
		(
			item_id = this.createGuidString()
		)

		item_data[#id] = item_id
		item_data[#title] = item_title
		item_data[#display_title] = item_title
		item_data[#menu_title] = item_title
		item_data[#buttonText] = item_title
		item_data[#button_text] = item_title
		item_data[#label] = item_title
		item_data[#category] = macro_category
		item_data[#macro] = macro_name
		item_data[#custom_title] = custom_title

		item_data -- return
	),


	/*
	Create separator item data.
	Stored as real ordered item, not macro and not submenu.
	*/
	function makeSeparatorItemData id:undefined =
	(
		separator_data = Dictionary #name
		separator_id = id

		if separator_id == undefined then
		(
			separator_id = this.createGuidString()
		)

		separator_data[#id] = separator_id
		separator_data[#title] = #SEPARATOR
		separator_data[#type] = #SEPARATOR
		separator_data[#separator] = true

		separator_data -- return
	),


	/* Normalize one separator index or an array of indexes. */
	function normalizeSeparatorIndexes separators_value item_count:undefined =
	(
		local separator_indexes = #()
		local normalized_indexes = #()

		if classOf separators_value == Integer then append separator_indexes separators_value
		else if classOf separators_value == Array then
			for separator_index in separators_value where classOf separator_index == Integer do
				append separator_indexes separator_index

		separator_indexes = sort separator_indexes
		for separator_index in separator_indexes do
		(
			local index_is_valid = separator_index > 0
			if item_count != undefined then
				if separator_index > item_count then index_is_valid = false
			if index_is_valid then appendIfUnique normalized_indexes separator_index
		)
		normalized_indexes -- return
	),


	/* Insert separators after the referenced original item indexes. */
	function insertSeparatorsInItemArray item_array separators:undefined =
	(
		local normalized_indexes = this.normalizeSeparatorIndexes separators item_count:item_array.count
		for normalized_index = normalized_indexes.count to 1 by -1 do
			insertItem (this.makeSeparatorItemData()) item_array (normalized_indexes[normalized_index] + 1)
		item_array -- return
	),


	/* Append an ordered item block at the requested target position. */
	function appendItemArrayToTarget item_array target_items index:undefined =
	(
		local insert_index = index
		for item_data in item_array do
		(
			if insert_index == undefined then append target_items item_data
			else
			(
				if insert_index < 1 then insert_index = 1
				if insert_index > target_items.count + 1 then insert_index = target_items.count + 1
				insertItem item_data target_items insert_index
				insert_index += 1
			)
		)
		target_items -- return
	),

	/*
	Create submenu item data.
	Submenu children are stored as ordered array.
	*/
	function makeSubMenuItemData submenu_title submenu_items id:undefined separators:undefined source_menu_title:undefined =
	(
		submenu_data = Dictionary #name
		submenu_id = id
		submenu_source_title = source_menu_title
		if submenu_source_title == undefined then submenu_source_title = submenu_title

		if submenu_id == undefined then
		(
			submenu_id = this.createGuidString()
		)

		submenu_data[#id] = submenu_id
		submenu_data[#title] = submenu_title
		submenu_data[#source_menu_title] = submenu_source_title
		submenu_data[#items] = submenu_items
		local separator_indexes = this.normalizeSeparatorIndexes separators item_count:submenu_items.count
		if separator_indexes.count > 0 then submenu_data[#separators] = separator_indexes

		submenu_data -- return
	),


	/*
	Create unresolved flat menu reference.
	Used when addMenu flat:true is called before target menu items are available.
	MenuBuildManager resolves this into real copied items during build.
	*/
	function makeFlatMenuReferenceData menu_title id:undefined separators:undefined =
	(
		flat_menu_data = Dictionary #name
		flat_menu_id = id

		if flat_menu_id == undefined then
		(
			flat_menu_id = this.createGuidString()
		)

		flat_menu_data[#id] = flat_menu_id
		flat_menu_data[#title] = menu_title
		flat_menu_data[#source_menu_title] = menu_title
		flat_menu_data[#items] = #()
		flat_menu_data[#flat_menu_reference] = true
		local separator_indexes = this.normalizeSeparatorIndexes separators
		if separator_indexes.count > 0 then flat_menu_data[#separators] = separator_indexes

		flat_menu_data -- return
	),


	/*
	Get manager instance.
	Falls back to global MenuBuildManager.
	*/
	function getManager =
	(
		found_manager = this.manager

		if found_manager == undefined then
		(
			try
			(
				global MenuBuildManager
				found_manager = MenuBuildManager
			)
			catch
			(
				found_manager = undefined
			)
		)

		found_manager -- return
	),


	/*
	Find a live native CUI menu by title.
	Searches top-level menus and their submenu hierarchy.
	*/
	function findNativeCuiMenuByTitle cui_menu menu_title =
	(
		local found_menu = undefined
		local current_title = ""
		local native_items = #()

		try (current_title = cui_menu.title as string) catch (current_title = "")
		if current_title == menu_title then
		(
			found_menu = cui_menu
		)
		else
		(
			try (native_items = cui_menu.menuItems) catch (native_items = #())

			for native_item in native_items while found_menu == undefined do
			(
				local is_submenu = false
				try (is_submenu = native_item.isSubMenu) catch (is_submenu = false)

				if is_submenu then
				(
					local submenu = undefined
					try (submenu = native_item.subMenu) catch (submenu = undefined)
					if submenu != undefined then found_menu = this.findNativeCuiMenuByTitle submenu menu_title
				)
			)
		)

		found_menu -- return
	),


	/* Get a native CUI menu by title from the current 3ds Max menu manager. */
	function getNativeCuiMenuByTitle menu_title =
	(
		local found_menu = undefined
		local menu_manager = undefined
		local top_level_menus = #()
		local quad_menu_manager = undefined
		local quad_contexts = #()

		try (menu_manager = maxOps.GetICuiMenuMgr()) catch (menu_manager = undefined)

		if menu_manager != undefined then
		(
			try (top_level_menus = menu_manager.topLevelMenus) catch (top_level_menus = #())

			for top_level_menu in top_level_menus while found_menu == undefined do
			(
				found_menu = this.findNativeCuiMenuByTitle top_level_menu menu_title
			)

			if found_menu == undefined then
			(
				local main_menu_bar = undefined
				try (main_menu_bar = menu_manager.mainMenuBar) catch (main_menu_bar = undefined)
				if main_menu_bar != undefined then found_menu = this.findNativeCuiMenuByTitle main_menu_bar menu_title
			)
		)

		if found_menu == undefined then
		(
			try (quad_menu_manager = maxOps.GetICuiQuadMenuMgr()) catch (quad_menu_manager = undefined)

			if quad_menu_manager != undefined then
			(
				try (quad_contexts = quad_menu_manager.contexts) catch (quad_contexts = #())

				for quad_context in quad_contexts while found_menu == undefined do
				(
					local quad_menus = #()
					try (quad_menus = quad_context.GetQuadMenus()) catch (quad_menus = #())

					for quad_menu in quad_menus while found_menu == undefined do
					(
						local quadrant_menus = #()
						try (quadrant_menus = quad_menu.menus) catch (quadrant_menus = #())

						for quadrant_menu in quadrant_menus while found_menu == undefined do
						(
							found_menu = this.findNativeCuiMenuByTitle quadrant_menu menu_title
						)
					)
				)
			)
		)

		found_menu -- return
	),


	/* Convert a live native CUI action into saved menu item data. */
	function makeNativeCuiActionItemData native_item =
	(
		local item_id = this.createGuidString()
		local item_title = ""
		local action_item = undefined
		local action_category = ""
		local action_name = ""

		try (item_title = native_item.title as string) catch (ok)
		try (action_item = native_item.actionItem) catch (action_item = undefined)

		if action_item != undefined then
		(
			try (action_category = action_item.category as string) catch (ok)
			try (action_name = action_item.menuText as string) catch (ok)
			if action_name == "" then try (action_name = action_item.buttonText as string) catch (ok)
			if action_name == "" then try (action_name = action_item.description as string) catch (ok)
			if action_name == "" then try (action_name = action_item.persistentActionId as string) catch (ok)
		)

		if item_title == "" then item_title = action_name
		local item_data = this.makeMacroItemData item_title action_category action_name custom_title:true id:item_id

		if action_item != undefined then
		(
			try (item_data[#action_table_id] = action_item.actionTableID) catch (ok)
			try (item_data[#persistent_action_id] = action_item.persistentActionId as string) catch (ok)
		)

		item_data -- return
	),


	/* Convert the ordered items of a live native CUI menu recursively. */
	function getNativeCuiMenuItems cui_menu =
	(
		local converted_items = #()
		local native_items = #()
		try (native_items = cui_menu.menuItems) catch (native_items = #())

		for native_item in native_items do
		(
			local item_id = this.createGuidString()
			local is_separator = false
			local is_submenu = false
			local is_action = false

			try (is_separator = native_item.isSeparator) catch (ok)
			try (is_submenu = native_item.isSubMenu) catch (ok)
			try (is_action = native_item.isAction) catch (ok)

			if is_separator then
			(
				append converted_items (this.makeSeparatorItemData id:item_id)
			)
			else if is_submenu then
			(
				local submenu = undefined
				local submenu_title = ""
				local submenu_items = #()
				try (submenu = native_item.subMenu) catch (submenu = undefined)
				if submenu != undefined then
				(
					try (submenu_title = submenu.title as string) catch (ok)
					submenu_items = this.getNativeCuiMenuItems submenu
				)
				append converted_items (this.makeSubMenuItemData submenu_title submenu_items id:item_id source_menu_title:submenu_title)
			)
			else if is_action then
			(
				append converted_items (this.makeNativeCuiActionItemData native_item)
			)
		)

		converted_items -- return
	),


	/* Resolve an ActionItem from its exact native action-table binding. */
	function findNativeActionItem action_table_id persistent_action_id =
	(
		local found_action = undefined

		for table_index = 1 to actionMan.numActionTables while found_action == undefined do
		(
			local action_table = actionMan.getActionTable table_index
			if action_table.id == action_table_id then
			(
				for action_index = 1 to action_table.numActionItems while found_action == undefined do
				(
					local action_item = action_table.getActionItem action_index
					local action_persistent_id = action_item.id as string
					try (action_persistent_id = action_item.getPersistentActionId()) catch (ok)
					if action_persistent_id == persistent_action_id then found_action = action_item
				)
			)
		)

		found_action -- return
	),


	/* Get one XML attribute without throwing when it is absent. */
	function getXmlAttributeValue xml_node attribute_name default_value =
	(
		local attribute_value = default_value
		local xml_attribute = undefined
		try (xml_attribute = xml_node.Attributes.GetNamedItem attribute_name) catch (xml_attribute = undefined)
		if xml_attribute != undefined then attribute_value = xml_attribute.Value as string

		attribute_value -- return
	),


	/*
	Get the legacy workspace menu source paired with the current CUI.
	Hidden context groups such as Context Spline Tools are stored here.
	*/
	function getLegacyWorkspaceMenuFilePath =
	(
		local menu_file_path = ""
		local current_cui_path = ""
		try (current_cui_path = cui.getConfigFile()) catch (current_cui_path = "")

		if current_cui_path != "" then
		(
			try
			(
				local cui_file = dotNetObject "System.IO.FileInfo" current_cui_path
				local ui_directory = cui_file.Directory.Parent.Parent.FullName
				local candidate_path = (dotNetClass "System.IO.Path").Combine ui_directory "MaxStartUI.mnux"
				if doesFileExist candidate_path then menu_file_path = candidate_path
			)
			catch
			(
				menu_file_path = ""
			)
		)

		menu_file_path -- return
	),


	/* Load a hidden native context menu from the active legacy workspace XML. */
	function loadLegacyWorkspaceMenuItemsByTitle menu_title =
	(
		local converted_items = #()
		local menu_file_path = this.getLegacyWorkspaceMenuFilePath()

		if menu_file_path != "" then
		(
			try
			(
				local xml_document = dotNetObject "System.Xml.XmlDocument"
				xml_document.Load menu_file_path
				local menu_nodes = xml_document.SelectNodes "//Menu"
				local found_menu_node = undefined

				if menu_nodes.Count > 0 then for menu_index = 0 to (menu_nodes.Count - 1) while found_menu_node == undefined do
				(
					local menu_node = menu_nodes.Item menu_index
					if (this.getXmlAttributeValue menu_node "title" "") == menu_title then found_menu_node = menu_node
				)

				if found_menu_node != undefined then
				(
					local child_nodes = found_menu_node.ChildNodes
					if child_nodes.Count > 0 then for child_index = 0 to (child_nodes.Count - 1) do
					(
						local xml_item = child_nodes.Item child_index
						if xml_item.Name == "Item" then
						(
							local mode_name = this.getXmlAttributeValue xml_item "modeName" ""

							if mode_name == "AM_SEPARATOR" then
							(
								append converted_items (this.makeSeparatorItemData())
							)
							else
							(
								local action_table_id = 0
								local persistent_action_id = this.getXmlAttributeValue xml_item "actionID" ""
								try (action_table_id = (this.getXmlAttributeValue xml_item "actionTableID" "0") as integer) catch (action_table_id = 0)

								if action_table_id != 0 and persistent_action_id != "" then
								(
									local action_item = this.findNativeActionItem action_table_id persistent_action_id
									local action_category = ""
									local action_name = persistent_action_id
									local item_title = this.getXmlAttributeValue xml_item "customTitle" ""

									if action_item != undefined then
									(
										try (action_category = action_item.category as string) catch (ok)
										try (action_name = action_item.menuText as string) catch (ok)
										if action_name == "" then try (action_name = action_item.buttonText as string) catch (ok)
										if action_name == "" then try (action_name = action_item.description as string) catch (ok)
									)
									else if action_table_id == 647394 then
									(
										local category_separator_index = findString persistent_action_id "`"
										if category_separator_index != undefined then
										(
											action_name = substring persistent_action_id 1 (category_separator_index - 1)
											action_category = substring persistent_action_id (category_separator_index + 1) (persistent_action_id.count - category_separator_index)
										)
									)

									if item_title == "" then item_title = action_name
									local item_data = this.makeMacroItemData item_title action_category action_name custom_title:((this.getXmlAttributeValue xml_item "customTitle" "") != "")
									item_data[#action_table_id] = action_table_id
									item_data[#persistent_action_id] = persistent_action_id
									append converted_items item_data
								)
							)
						)
					)
				)
			)
			catch
			(
				format "MenuDefinition_v.loadLegacyWorkspaceMenuItemsByTitle failed. title:'%' error:%\n" menu_title (getCurrentException())
				converted_items = #()
			)
		)

		converted_items -- return
	),


	/* Load ordered items from a live native 3ds Max menu with the requested title. */
	function loadNativeMenuItemsByTitle menu_title =
	(
		local native_items = #()
		local native_menu = this.getNativeCuiMenuByTitle menu_title
		if native_menu != undefined then native_items = this.getNativeCuiMenuItems native_menu
		if native_items.count == 0 then native_items = this.loadLegacyWorkspaceMenuItemsByTitle menu_title

		native_items -- return
	),


	/*
	Clone dictionary recursively.
	Used when copying existing menu data.
	*/
	function cloneDictionaryValue source_dictionary =
	(
		source_keys = GetDictKeys source_dictionary
		dictionary_type = #string

		if source_keys.count > 0 then
		(
			if classOf source_keys[1] == Name then
			(
				dictionary_type = #name
			)
		)

		cloned_dictionary = Dictionary dictionary_type

		for source_key in source_keys do
		(
			cloned_dictionary[source_key] = this.cloneValue source_dictionary[source_key]
		)

		cloned_dictionary -- return
	),


	/*
	Clone array recursively.
	Preserves ordered item arrays.
	*/
	function cloneArrayValue source_array =
	(
		cloned_array = #()

		for source_value in source_array do
		(
			append cloned_array (this.cloneValue source_value)
		)

		cloned_array -- return
	),


	/*
	Clone supported value.
	Handles arrays and dictionaries.
	*/
	function cloneValue source_value =
	(
		cloned_value = source_value

		if this.isDictionaryValue source_value then
		(
			cloned_value = this.cloneDictionaryValue source_value
		)
		else
		(
			if this.isArrayValue source_value then
			(
				cloned_value = this.cloneArrayValue source_value
			)
		)

		cloned_value -- return
	),


	/*
	Append item to ordered array.
	Optional index inserts item at requested position.
	*/
	function appendSavedItem item_data index:undefined =
	(
		items_array = this.ensureItemsArray()

		if index == undefined then
		(
			append items_array item_data
		)
		else
		(
			if index < 1 then
			(
				index = 1
			)

			if index > items_array.count + 1 then
			(
				index = items_array.count + 1
			)

			insertItem item_data items_array index
		)

		this.last_added_item = item_data
		item_data -- return
	),


	/*
	Clear ordered items.
	Keeps submenu parent item synchronized.
	*/
	function clearItems =
	(
		this.setActiveData #()

		if this.type == #quad and this.quad_position != undefined then
		(
			this.clear_default_menu = true
		)

		this -- return
	),


	/*
	Add macro or grouped native action once per group, category, name, and title.
	Returns existing item data when already present, preserving its ID and position.
	*/
	function addItem macro_category macro_name title:"" group:"" index:undefined =
	(
		--format "\n"; print "MenuDefinition_v.addItem()"
		--format "macro_category: %\n" macro_category
		--format "macro_name: %\n" macro_name
		--format "title: %\n" title

		
		local item_title = title
		local action_group = if group == undefined then "" else group as string
		if item_title == "" then item_title = macro_name as string

		local item_data = undefined
		local items_array = this.ensureItemsArray()
		for saved_item in items_array while item_data == undefined do
		(
			if this.hasDictValueSafe saved_item #category and this.hasDictValueSafe saved_item #macro and this.hasDictValueSafe saved_item #title then
			(
				if not (this.hasDictValueSafe saved_item #items) then
				(
					local saved_group = if this.hasDictValueSafe saved_item #group then saved_item[#group] else ""
					if saved_group == action_group and saved_item[#category] == macro_category and saved_item[#macro] == macro_name and saved_item[#title] == item_title then
						item_data = saved_item
				)
			)
		)
		--format "item_data: %\n" item_data

		if item_data == undefined then
		(
			item_data = this.makeMacroItemData item_title macro_category macro_name custom_title:(title != "")
			if action_group != "" then item_data[#group] = action_group
			this.appendSavedItem item_data index:index
		)

		this.last_added_item = item_data
		item_data -- return
	),


	function isSeparatorData item_data =
	(
		local is_separator = false
		if this.hasDictValueSafe item_data #separator then is_separator = (item_data[#separator] == true)
		if this.hasDictValueSafe item_data #type then
			if item_data[#type] == #SEPARATOR then is_separator = true
		if this.hasDictValueSafe item_data #title then
			if item_data[#title] == #SEPARATOR then is_separator = true
		is_separator -- return
	),


	/*
	Add a separator after the last added or reused item, or at an explicit index.
	Reuse an adjacent separator so repeated script runs do not add another one.
	*/
	function addSeparator index:undefined =
	(
		local items_array = this.ensureItemsArray()
		local insert_index = index
		if insert_index == undefined then
		(
			local anchor_index = findItem items_array this.last_added_item
			insert_index = if anchor_index > 0 then anchor_index + 1 else items_array.count + 1
		)
		if insert_index < 1 then insert_index = 1
		if insert_index > items_array.count + 1 then insert_index = items_array.count + 1

		local separator_data = undefined
		if insert_index > 1 then
			if this.isSeparatorData items_array[insert_index - 1] then separator_data = items_array[insert_index - 1]
		if separator_data == undefined and insert_index <= items_array.count then
			if this.isSeparatorData items_array[insert_index] then separator_data = items_array[insert_index]

		if separator_data == undefined then
		(
			separator_data = this.makeSeparatorItemData()
			this.appendSavedItem separator_data index:insert_index
		)
		this.last_added_item = separator_data
		separator_data -- return
	),


	/* Resolve a string title from either a title value or MenuDefinition_v. */
	function getMenuReferenceTitle menu_reference =
	(
		local menu_title = ""

		if menu_reference != undefined then
		(
			try (menu_title = menu_reference.title as string) catch (menu_title = menu_reference as string)
		)

		menu_title -- return
	),


	/*
	Load existing menu items by title or directly from MenuDefinition_v.
	Uses manager saved data when available.
	*/
	function loadExistingMenuItems menu_reference =
	(
		local menu_items = #()
		local menu_title = this.getMenuReferenceTitle menu_reference
		local menu_manager = this.getManager()

		try
		(
			local definition_items = menu_reference.getActiveData()
			if this.isArrayValue definition_items then menu_items = this.cloneArrayValue definition_items
		)
		catch
		(
			menu_items = #()
		)

		if menu_items.count == 0 and menu_manager != undefined then
		(
			try
			(
				menu_definition = menu_manager.findMenuDefinitionByTitle menu_title

				if menu_definition != undefined then
				(
					try
					(
						definition_items = menu_definition.getActiveData()

						if this.isArrayValue definition_items then
						(
							menu_items = this.cloneArrayValue definition_items
						)
					)
					catch
					(
						menu_items = #()
					)
				)
			)
			catch
			(
				menu_items = #()
			)
		)

		if menu_items.count == 0 then
		(
			if menu_manager != undefined then
			(
				try
				(
					saved_menu_data = menu_manager.findSavedMenuDataByTitle menu_title

					if saved_menu_data != undefined then
					(
						if menu_manager.hasDictValueSafe saved_menu_data #items then
						(
							menu_items = this.cloneArrayValue saved_menu_data[#items]
						)
					)
				)
				catch
				(
					menu_items = #()
				)
			)
		)

		menu_items -- return
	),


	/*
	Append existing menu items into this menu.
	Used by addMenu flat:true.
	*/
	function appendExistingMenuItems menu_reference index:undefined separators:undefined =
	(
		target_items = this.ensureItemsArray()
		menu_title = this.getMenuReferenceTitle menu_reference
		source_items = this.loadExistingMenuItems menu_reference

		if source_items.count > 0 then
		(
			local copied_items = #()
			for source_item in source_items do
				append copied_items (this.cloneValue source_item)
			this.insertSeparatorsInItemArray copied_items separators:separators
			this.appendItemArrayToTarget copied_items target_items index:index
		)
		else
		(
			this.appendSavedItem (this.makeFlatMenuReferenceData menu_title separators:separators) index:index
		)

		target_items -- return
	),


	/*
	Add submenu or flattened existing menu.
	Returns MenuDefinition_v for submenu when flat:false.
	*/
	function addSubMenu menu_reference index:undefined separators:undefined title:undefined =
	(
		menu_title = this.getMenuReferenceTitle menu_reference
		submenu_title = menu_title
		if title != undefined and title != "" then submenu_title = title
		submenu_items = this.loadExistingMenuItems menu_reference
		this.insertSeparatorsInItemArray submenu_items separators:separators
		submenu_data = this.makeSubMenuItemData submenu_title submenu_items separators:separators source_menu_title:menu_title
		this.appendSavedItem submenu_data index:index

		submenu_definition = MenuDefinition_v \
			type:#menu \
			title:submenu_title \
			data:submenu_items \
			_data:submenu_items \
			manager:(this.getManager()) \
			parent_item_data:submenu_data \
			qmnx_clear_directory:this.qmnx_clear_directory \
			clear_default_menu:this.clear_default_menu

		submenu_definition -- return
	),


	/*
	Add existing menu.
	flat:true copies the source menu items into this menu.
	flat:false creates a real submenu, including inside quad menus.
	*/
	function addMenu menu_reference flat:false index:undefined separators:undefined title:undefined =
	(
		result_data = undefined
		effective_flat = flat

		if effective_flat then
		(
			this.appendExistingMenuItems menu_reference index:index separators:separators
			result_data = this
		)
		else
		(
			result_data = this.addSubMenu menu_reference index:index separators:separators title:title
		)

		result_data -- return
	),


	/*
	OOP-friendly submenu getter/creator.
	Creates a real submenu definition.
	*/
	function menu menu_title index:undefined separators:undefined title:undefined =
	(
		submenu_definition = this.addSubMenu menu_title index:index separators:separators title:title

		submenu_definition -- return
	),


	/*
	Add or get quad position definition.
	Quad menu data is array of MenuDefinition_v quad positions.
	*/
	function addQuad quad_title position:#BottomRight =
	(
		quad_array = this.ensureItemsArray()
		normalized_position = this.normalizeQuadPosition position
		found_quad = undefined

		for quad_definition in quad_array while found_quad == undefined do
		(
			try
			(
				if quad_definition.quad_position == normalized_position then
				(
					found_quad = quad_definition
				)
			)
			catch
			(
				ok
			)
		)

		if found_quad == undefined then
		(
			found_quad = MenuDefinition_v \
				type:#quad \
				title:quad_title \
				data:#() \
				quad_modifier:this.quad_modifier \
				quad_position:normalized_position \
				quad_context_id:this.quad_context_id \
				manager:this.manager \
				qmnx_clear_directory:this.qmnx_clear_directory \
				clear_default_menu:this.clear_default_menu

			append quad_array found_quad
			quad_array = this.reorderQuadArray quad_array
			this.setActiveData quad_array
		)

		found_quad -- return
	),

	/*
	Get quad by position.
	1=BottomRight, 2=TopRight, 3=TopLeft, 4=BottomLeft.
	*/
	function getQuad quad_position_value =
	(
		normalized_position = this.normalizeQuadPosition quad_position_value
		quad_title = this.getQuadTitleFromPosition normalized_position

		this.addQuad quad_title position:normalized_position -- return
	),


	/*
	Create or get quad position by title.
	Useful when a quad position needs custom visible title.
	*/
	function quad quad_title position:undefined =
	(
		quad_position_value = position

		if quad_position_value == undefined then
		(
			quad_position_value = (this.ensureItemsArray()).count + 1
		)

		this.addQuad quad_title position:quad_position_value -- return
	),


	/*
	Set definition title.
	Keeps submenu parent item title synchronized.
	*/
	function setTitle new_title =
	(
		this.title = new_title as string

		if this.parent_item_data != undefined then
		(
			if this.isDictionaryValue this.parent_item_data then
			(
				this.parent_item_data[#title] = this.title

				if this.hasDictValueSafe this.parent_item_data #source_menu_title then
				(
					this.parent_item_data[#source_menu_title] = this.title
				)
			)
		)

		this -- return
	),


	/*
	Set QMNX clear directory.
	Fluent setter.
	*/
	function setQmnxClearDirectory directory_path =
	(
		this.qmnx_clear_directory = directory_path

		this -- return
	),


	/*
	Set default clear state.
	Fluent setter.
	*/
	function setClearDefaultMenu state =
	(
		this.clear_default_menu = state

		this -- return
	),


	on create do
	(
		if this.data == undefined and this._data == undefined then
		(
			if this.title != undefined and this.title != "" then
			(
				this.data = this.loadNativeMenuItemsByTitle (this.title as string)
			)
		)

		if this.data == undefined then
		(
			this.data = #()
		)

		if this._data == undefined then
		(
			this._data = this.data
		)

		if this.parent_item_data != undefined then
		(
			if this.isDictionaryValue this.parent_item_data then
			(
				this.parent_item_data[#items] = this.data
			)
		)
	)
)
