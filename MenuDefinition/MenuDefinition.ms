/*
	MenuDefinition_v
	Version: 0.43
	Purpose: Ordered menu definition with OOP-friendly submenu creation, ordered quads, title aliases, and deferred menu reference resolving.
*/

global MenuDefinition_v

struct MenuDefinition_v
(
	version = 0.44,
	type = #menu,
	title = "",
	data = undefined,
	_data = undefined,
	quad_modifier = undefined,
	quad_position = undefined,
	quad_context_id = "ac7c70f8-3f86-4ff5-a510-e4fd6a9c368e",
	manager = undefined,
	parent_item_data = undefined,
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
		item_data[#display_title] = item_title
		item_data[#menu_title] = item_title
		item_data[#buttonText] = item_title
		item_data[#button_text] = item_title
		item_data[#label] = item_title
		item_data[#category] = macro_category
		item_data[#macro] = macro_name

		item_data -- return
	),

	/*
	Create submenu item data.
	Submenu children are stored as ordered array.
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
		submenu_data[#source_menu_title] = submenu_title
		submenu_data[#items] = submenu_items

		submenu_data -- return
	),


	/*
	Create unresolved flat menu reference.
	Used when addMenu flat:true is called before target menu items are available.
	MenuBuildManager resolves this into real copied items during build.
	*/
	function makeFlatMenuReferenceData menu_title id:undefined =
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

		item_data -- return
	),


	/*
	Clear ordered items.
	Keeps submenu parent item synchronized.
	*/
	function clearItems =
	(
		this.setActiveData #()

		this -- return
	),


	/*
	Add macro item.
	Returns created item data dictionary.
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
	Load existing menu items by title.
	Uses manager saved data when available.
	*/
	function loadExistingMenuItems menu_title =
	(
		menu_items = #()
		menu_manager = this.getManager()

		if menu_manager != undefined then
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
	function appendExistingMenuItems menu_title index:undefined =
	(
		target_items = this.ensureItemsArray()
		source_items = this.loadExistingMenuItems menu_title

		if source_items.count > 0 then
		(
			insert_index = index

			for source_item in source_items do
			(
				copied_item = this.cloneValue source_item

				if insert_index == undefined then
				(
					append target_items copied_item
				)
				else
				(
					if insert_index < 1 then
					(
						insert_index = 1
					)

					if insert_index > target_items.count + 1 then
					(
						insert_index = target_items.count + 1
					)

					insertItem copied_item target_items insert_index
					insert_index += 1
				)
			)
		)
		else
		(
			this.appendSavedItem (this.makeFlatMenuReferenceData menu_title) index:index
		)

		target_items -- return
	),


	/*
	Add submenu or flattened existing menu.
	Returns MenuDefinition_v for submenu when flat:false.
	*/
	function addSubMenu menu_title index:undefined =
	(
		submenu_items = this.loadExistingMenuItems menu_title
		submenu_data = this.makeSubMenuItemData menu_title submenu_items
		this.appendSavedItem submenu_data index:index

		submenu_definition = MenuDefinition_v \
			type:#menu \
			title:menu_title \
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
	Main menus use submenu by default.
	Quad menus flatten by default because nested menu references can exist in the editor but do not show in the runtime quad popup.
	*/
	function addMenu menu_title flat:false index:undefined =
	(
		result_data = undefined
		effective_flat = flat

		if this.type == #quad then
		(
			effective_flat = true
		)

		if effective_flat then
		(
			this.appendExistingMenuItems menu_title index:index
			result_data = this
		)
		else
		(
			result_data = this.addSubMenu menu_title index:index
		)

		result_data -- return
	),


	/*
	OOP-friendly submenu getter/creator.
	Creates a real submenu definition. In quad runtime, prefer addMenu() because addMenu() flattens menu items into the quad.
	*/
	function menu menu_title index:undefined =
	(
		submenu_definition = this.addSubMenu menu_title index:index

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
