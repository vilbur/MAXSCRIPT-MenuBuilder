/*
	MenuDefinition_v 0.39
	Ordered item model: data is Array, item id is inside item object.
*/
struct MenuDefinition_v
(
	version = 0.39,
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

	/*
	Create guid string.
	Used for ordered item ids.
	*/
	function createGuidString =
	(
		guid_class = dotNetClass "System.Guid"
		guid_value = guid_class.NewGuid()

		guid_value.ToString() -- return
	),

	/*
	Check Dictionary value.
	Safe wrapper for class test.
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
	Used for ordered items.
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
	Safe dictionary key test.
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
	Get active data storage.
	_data is kept for backward compatibility.
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
	Set active data storage.
	Keeps data and _data synced.
	*/
	function setActiveData value =
	(
		this.data = value
		this._data = value

		value -- return
	),

	/*
	Ensure ordered array storage.
	Menu items are stored in order.
	*/
	function ensureItemsArray =
	(
		active_data = this.getActiveData()

		if not this.isArrayValue active_data then
		(
			active_data = #()
			this.setActiveData active_data
		)

		active_data -- return
	),

	/*
	Normalize quad position.
	Accepts 1-4 or common names.
	*/
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

	/*
	Get visible quad title from position.
	Used when quad is auto-created.
	*/
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

	/*
	Create ordered macro item object.
	Item id is stored as property, not as dictionary key.
	*/
	function makeMacroItemData item_title macro_category macro_name id:undefined =
	(
		item_data = Dictionary #name
		item_id = id

		if item_id == undefined then
		(
			item_id = this.createGuidString()
		)

		item_data[#id] = item_id
		item_data[#title] = item_title
		item_data[#category] = macro_category
		item_data[#macro] = macro_name

		item_data -- return
	),

	/*
	Create ordered submenu item object.
	Child items are also ordered arrays.
	*/
	function makeSubMenuItemData submenu_title submenu_items id:undefined =
	(
		submenu_data = Dictionary #name
		submenu_id = id

		if submenu_id == undefined then
		(
			submenu_id = this.createGuidString()
		)

		submenu_data[#id] = submenu_id
		submenu_data[#title] = submenu_title
		submenu_data[#items] = submenu_items

		submenu_data -- return
	),

	/*
	Resolve owning MenuBuildManager.
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
	Clone dictionary object.
	Used for safe copy of saved items.
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
	Preserves ordered item list.
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
	Handles dictionaries and arrays.
	*/
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

	/*
	Append item to ordered array.
	Optional index rebuilds array to insert item.
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

		item_data -- return
	),

	/*
	Clear ordered item array.
	Used before pasting whole menu into quad.
	*/
	function clearItems =
	(
		this.setActiveData #()

		this -- return
	),

	/*
	Add macro item.
	Stored as ordered object in data array.
	*/
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

	/*
	Load ordered items from existing saved menu.
	Used for addMenu flat:true and flat:false.
	*/
	function loadExistingMenuItems menu_title =
	(
		menu_items = #()
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
						menu_items = this.cloneArrayValue saved_menu_data[#items]
					)
				)
			)
			catch
			(
				menu_items = #()
			)
		)

		menu_items -- return
	),

	/*
	Append existing menu items into current ordered list.
	Keeps source order.
	*/
	function appendExistingMenuItems menu_title =
	(
		target_items = this.ensureItemsArray()
		source_items = this.loadExistingMenuItems menu_title

		for source_item in source_items do
		(
			append target_items (this.cloneValue source_item)
		)

		target_items -- return
	),

	/*
	Add existing menu as submenu or flatten it.
	flat:true pastes items directly into current menu/quad.
	*/
	function addMenu menu_title flat:false index:undefined =
	(
		result_data = undefined

		if flat then
		(
			this.appendExistingMenuItems menu_title
			result_data = this
		)
		else
		(
			submenu_items = this.loadExistingMenuItems menu_title
			submenu_data = this.makeSubMenuItemData menu_title submenu_items

			this.appendSavedItem submenu_data index:index

			result_data = MenuDefinition_v \
				type:#menu \
				title:menu_title \
				data:submenu_items \
				_data:submenu_items \
				manager:(this.getManager()) \
				qmnx_clear_directory:this.qmnx_clear_directory \
				clear_default_menu:this.clear_default_menu
		)

		result_data -- return
	),

	/*
	Add or get quad position definition.
	Quad menu definition data is array of quad definitions.
	*/
	function addQuad quad_title position:#TopRight =
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
			this.setActiveData quad_array
		)

		found_quad -- return
	),

	/*
	Get quad by position index or name.
	1=TopRight, 2=TopLeft, 3=BottomLeft, 4=BottomRight.
	*/
	function getQuad quad_position_value =
	(
		normalized_position = this.normalizeQuadPosition quad_position_value
		quad_title = this.getQuadTitleFromPosition normalized_position

		this.addQuad quad_title position:normalized_position -- return
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
	Set clear default menu state.
	Fluent setter.
	*/
	function setClearDefaultMenu state =
	(
		this.clear_default_menu = state

		this -- return
	),

	on create do
	(
		if this.data == undefined then
		(
			this.data = #()
		)

		if this._data == undefined then
		(
			this._data = this.data
		)
	)
)
