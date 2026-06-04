
struct MenuDefinition_v
(
	type = #menu,
	title = "",
	id = "",
	quad_menu_id = "",
	data = undefined,
	_data = undefined,
	quad_modifier = undefined,
	quad_position = #TopRight,
	quad_context_id = "ac7c70f8-3f86-4ff5-a510-e4fd6a9c368e",
	qmnx_clear_directory = "",
	clear_defaul_menu = false,
	clear_default_menu = false,


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


	/*  Checks if value is array.
	    Used for quad definitions array.
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


	/*  Safely checks dictionary key.
	    Prevents key-type crashes.
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


	/*  Reads constructor alias _data.
	    Alias exists only to support typo-safe constructor calls.
	*/
	function readDataAlias =
	(
		if this._data != undefined then
		(
			this.data = this._data
		)

		this.data -- return
	),


	/*  Checks if item data is saved submenu data.
	    Saved submenu has #items key.
	*/
	function isSavedSubMenuData item_data =
	(
		was_found = false

		if this.isDictionaryValue item_data then
		(
			was_found = this.hasDictValueSafe item_data #items
		)

		was_found -- return
	),


	/*  Finds saved item dictionary key by item title.
	    Used to update existing JSON-backed menu items.
	*/
	function findSavedItemKeyByTitle item_title submenu_only:false =
	(
		found_key = undefined

		this.ensureMenuData()

		data_keys = GetDictKeys this.data

		for data_key in data_keys while found_key == undefined do
		(
			item_data = this.data[data_key]

			if this.isDictionaryValue item_data then
			(
				if this.hasDictValueSafe item_data #title then
				(
					if item_data[#title] == item_title then
					(
						if submenu_only then
						(
							if this.isSavedSubMenuData item_data then
							(
								found_key = data_key
							)
						)
						else
						(
							found_key = data_key
						)
					)
				)
			)
		)

		found_key -- return
	),


	/*  Ensures data property is Dictionary #string.
	    Used for normal menu content.
	*/
	function ensureMenuData =
	(
		this.readDataAlias()

		if not this.isDictionaryValue this.data then
		(
			this.data = Dictionary #string
		)

		this.data -- return
	),


	/*  Ensures data property is array.
	    Used when definition owns multiple quad definitions.
	*/
	function ensureQuadData =
	(
		this.readDataAlias()

		if not this.isArrayValue this.data then
		(
			this.data = #()
		)

		this.data -- return
	),


	/*  Adds or updates macro item to menu data.
	    Existing saved item with same title is updated in place.
	*/
	function addItem category macro_name title:"" =
	(
		this.ensureMenuData()

		item_title = title

		if item_title == "" then
		(
			item_title = macro_name
		)

		existing_key = this.findSavedItemKeyByTitle item_title

		if existing_key != undefined then
		(
			item_data = this.data[existing_key]

			if this.isDictionaryValue item_data then
			(
				item_data[#title] = item_title
				item_data[#category] = category
				item_data[#macro] = macro_name
			)
			else
			(
				this.data[item_title] = #(category, macro_name)
			)
		)
		else
		(
			this.data[item_title] = #(category, macro_name)
		)

		this -- return
	),


	/*  Adds or gets submenu definition from menu data.
	    Existing saved submenu with same title returns definition using same #items dictionary.
	*/
	function addMenu title =
	(
		this.ensureMenuData()

		existing_key = this.findSavedItemKeyByTitle title submenu_only:true

		if existing_key != undefined then
		(
			item_data = this.data[existing_key]

			menu_definition = MenuDefinition_v \
				type:#menu \
				title:title \
				data:item_data[#items]
		)
		else
		(
			menu_definition = MenuDefinition_v \
				type:#menu \
				title:title

			this.data[title] = menu_definition.data
		)

		menu_definition -- return
	),


	/*  Finds existing quad definition by title and position.
	    Used when JSON-backed quad menu is modified by several tools.
	*/
	function findQuadDefinition title position:#TopRight =
	(
		quad_definition = undefined

		this.ensureQuadData()

		for item_definition in this.data while quad_definition == undefined do
		(
			if item_definition.title == title then
			(
				if item_definition.quad_position == position then
				(
					quad_definition = item_definition
				)
			)
		)

		quad_definition -- return
	),


	/*  Adds or gets quad quadrant definition.
	    Parent data becomes array of MenuDefinition_v.
	*/
	function addQuad title position:#TopRight =
	(
		this.ensureQuadData()

		quad_definition = this.findQuadDefinition title position:position

		if quad_definition == undefined then
		(
			quad_definition = MenuDefinition_v \
				type:#quad \
				title:title \
				quad_modifier:this.quad_modifier \
				quad_position:position \
				quad_context_id:this.quad_context_id \
				qmnx_clear_directory:this.qmnx_clear_directory \
				clear_defaul_menu:this.clear_defaul_menu \
				clear_default_menu:this.clear_default_menu

			append this.data quad_definition
		)

		quad_definition -- return
	),


	/*  Sets default clear flag using user typo-compatible property.
	    Both spellings are synchronized.
	*/
	function setClearDefaulMenu state =
	(
		this.clear_defaul_menu = state
		this.clear_default_menu = state

		this -- return
	),


	on create do
	(
		this.readDataAlias()

		type_text = this.type as string

		if type_text == "#menu" then
		(
			this.quad_position = undefined
		)

		if type_text == "#MENU" then
		(
			this.quad_position = undefined
		)

		if type_text == "menu" then
		(
			this.quad_position = undefined
		)

		if type_text == "MENU" then
		(
			this.quad_position = undefined
		)

		if this.clear_default_menu then
		(
			this.clear_defaul_menu = true
		)

		if this.clear_defaul_menu then
		(
			this.clear_default_menu = true
		)

		if this.data == undefined then
		(
			this.data = Dictionary #string
		)
	)
)


