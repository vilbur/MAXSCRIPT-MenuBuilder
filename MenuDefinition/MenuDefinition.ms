/*
	MenuDefinition_v 0.36

	User-facing menu / quad definition container.

	Rules:
	- correct property: clear_default_menu
	- has version property
	- no required id / quad_menu_id property
*/

struct MenuDefinition_v
(
	version = 0.36,
	type = #menu,
	title = "",
	data = undefined,
	_data = undefined,
	quad_modifier = undefined,
	quad_position = undefined,
	quad_context_id = "ac7c70f8-3f86-4ff5-a510-e4fd6a9c368e",
	manager = undefined,
	qmnx_clear_directory = "",
	clear_default_menu = false,


	function createGuidString =
	(
		guid_class = dotNetClass "System.Guid"
		guid_value = guid_class.NewGuid()

		guid_value.ToString() -- return
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


	function getActiveData =
	(
		active_data = this.data

		if this._data != undefined then
		(
			active_data = this._data
		)

		active_data -- return
	),


	function setActiveData value =
	(
		this.data = value
		this._data = value

		value -- return
	),


	function ensureItemsDictionary =
	(
		active_data = this.getActiveData()

		if not this.isDictionaryValue active_data then
		(
			active_data = Dictionary #string
			this.setActiveData active_data
		)

		active_data -- return
	),


	function ensureQuadArray =
	(
		active_data = this.getActiveData()

		if not this.isArrayValue active_data then
		(
			active_data = #()
			this.setActiveData active_data
		)

		active_data -- return
	),


	function normalizeQuadPosition quad_position_value =
	(
		normalized_position = #TopRight

		if classOf quad_position_value == Integer then
		(
			case quad_position_value of
			(
				1: normalized_position = #TopRight
				2: normalized_position = #TopLeft
				3: normalized_position = #BottomLeft
				4: normalized_position = #BottomRight
				default: normalized_position = #TopRight
			)
		)
		else
		(
			position_text = quad_position_value as string

			case position_text of
			(
				"#TopRight": normalized_position = #TopRight
				"TopRight": normalized_position = #TopRight
				"topRight": normalized_position = #TopRight
				"top_right": normalized_position = #TopRight
				"Top Right": normalized_position = #TopRight

				"#TopLeft": normalized_position = #TopLeft
				"TopLeft": normalized_position = #TopLeft
				"topLeft": normalized_position = #TopLeft
				"top_left": normalized_position = #TopLeft
				"Top Left": normalized_position = #TopLeft

				"#BottomLeft": normalized_position = #BottomLeft
				"BottomLeft": normalized_position = #BottomLeft
				"bottomLeft": normalized_position = #BottomLeft
				"bottom_left": normalized_position = #BottomLeft
				"Bottom Left": normalized_position = #BottomLeft

				"#BottomRight": normalized_position = #BottomRight
				"BottomRight": normalized_position = #BottomRight
				"bottomRight": normalized_position = #BottomRight
				"bottom_right": normalized_position = #BottomRight
				"Bottom Right": normalized_position = #BottomRight

				default: normalized_position = #TopRight
			)
		)

		normalized_position -- return
	),


	function getQuadTitleFromPosition quad_position_value =
	(
		normalized_position = this.normalizeQuadPosition quad_position_value
		quad_title = "Top Right"

		case normalized_position of
		(
			#TopRight: quad_title = "Top Right"
			#TopLeft: quad_title = "Top Left"
			#BottomLeft: quad_title = "Bottom Left"
			#BottomRight: quad_title = "Bottom Right"
			default: quad_title = "Top Right"
		)

		quad_title -- return
	),


	function makeMacroItemData item_title macro_category macro_name =
	(
		item_data = Dictionary #name

		item_data[#title] = item_title
		item_data[#category] = macro_category
		item_data[#macro] = macro_name

		item_data -- return
	),


	function makeSubMenuItemData submenu_title submenu_items =
	(
		submenu_data = Dictionary #name

		submenu_data[#title] = submenu_title
		submenu_data[#items] = submenu_items

		submenu_data -- return
	),


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


	function cloneArrayValue source_array =
	(
		cloned_array = #()

		for source_value in source_array do
		(
			append cloned_array (this.cloneValue source_value)
		)

		cloned_array -- return
	),


	function cloneValue source_value =
	(
		cloned_value = source_value

		if this.isDictionaryValue source_value then
		(
			cloned_value = this.cloneDictionaryValue source_value
		)
		else if classOf source_value == Array then
		(
			cloned_value = this.cloneArrayValue source_value
		)

		cloned_value -- return
	),


	function appendSavedItem item_data index:undefined =
	(
		items_dictionary = this.ensureItemsDictionary()
		item_key = this.createGuidString()

		if index == undefined then
		(
			items_dictionary[item_key] = item_data
		)
		else
		(
			new_dictionary = Dictionary #string
			old_keys = GetDictKeys items_dictionary
			inserted = false

			for key_index = 1 to old_keys.count do
			(
				if key_index == index then
				(
					new_dictionary[item_key] = item_data
					inserted = true
				)

				old_key = old_keys[key_index]
				new_dictionary[old_key] = items_dictionary[old_key]
			)

			if not inserted then
			(
				new_dictionary[item_key] = item_data
			)

			this.setActiveData new_dictionary
		)

		item_data -- return
	),


	function clearItems =
	(
		this.setActiveData (Dictionary #string)

		this -- return
	),


	function addItem macro_category macro_name title:"" index:undefined =
	(
		item_title = title

		if item_title == "" then
		(
			item_title = macro_name as string
		)

		item_data = this.makeMacroItemData item_title macro_category macro_name
		this.appendSavedItem item_data index:index

		item_data -- return
	),


	function loadExistingMenuItems menu_title =
	(
		menu_items = Dictionary #string
		menu_manager = this.getManager()

		if menu_manager != undefined then
		(
			try
			(
				saved_menu_data = menu_manager.findSavedMenuDataByTitle menu_title

				if saved_menu_data != undefined then
				(
					if menu_manager.hasDictValueSafe saved_menu_data #items then
					(
						menu_items = this.cloneDictionaryValue saved_menu_data[#items]
					)
				)
			)
			catch
			(
				menu_items = Dictionary #string
			)
		)

		menu_items -- return
	),


	function appendExistingMenuItems menu_title =
	(
		target_items = this.ensureItemsDictionary()
		source_items = this.loadExistingMenuItems menu_title
		source_keys = GetDictKeys source_items

		for source_key in source_keys do
		(
			target_items[this.createGuidString()] = this.cloneValue source_items[source_key]
		)

		target_items -- return
	),


	function addMenu menu_title flat:false index:undefined =
	(
		result_data = undefined

		if flat then
		(
			result_data = this.appendExistingMenuItems menu_title
		)
		else
		(
			submenu_items = this.loadExistingMenuItems menu_title
			submenu_data = this.makeSubMenuItemData menu_title submenu_items

			this.appendSavedItem submenu_data index:index

			result_data = submenu_data
		)

		result_data -- return
	),


	function addQuad quad_title position:#TopRight =
	(
		quad_array = this.ensureQuadArray()
		normalized_position = this.normalizeQuadPosition position
		found_quad = undefined

		for quad_definition in quad_array while found_quad == undefined do
		(
			if quad_definition.quad_position == normalized_position then
			(
				found_quad = quad_definition
			)
		)

		if found_quad == undefined then
		(
			found_quad = MenuDefinition_v \
				type:#quad \
				title:quad_title \
				data:(Dictionary #string) \
				quad_modifier:this.quad_modifier \
				quad_position:normalized_position \
				quad_context_id:this.quad_context_id \
				manager:this.manager \
				qmnx_clear_directory:this.qmnx_clear_directory \
				clear_default_menu:this.clear_default_menu

			append quad_array found_quad
			this.setActiveData quad_array
		)

		found_quad -- return
	),


	function getQuad quad_position_value =
	(
		normalized_position = this.normalizeQuadPosition quad_position_value
		quad_title = this.getQuadTitleFromPosition normalized_position

		this.addQuad quad_title position:normalized_position -- return
	),


	function setQmnxClearDirectory directory_path =
	(
		this.qmnx_clear_directory = directory_path

		this -- return
	),


	function setClearDefaultMenu state =
	(
		this.clear_default_menu = state

		this -- return
	),


	on create do
	(
		if this.data == undefined then
		(
			if this.type == #quad and this.title != "" then
			(
				this.data = #()
			)
			else
			(
				this.data = Dictionary #string
			)
		)

		if this._data == undefined then
		(
			this._data = this.data
		)
	)
)
