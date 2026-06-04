
struct MenuDefinition_v
(
	type = #menu,
	title = "",
	data = undefined,
	_data = undefined,
	quad_modifier = undefined,
	quad_position = #TopRight,
	quad_context_id = "ac7c70f8-3f86-4ff5-a510-e4fd6a9c368e",


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


	function readDataAlias =
	(
		if this._data != undefined then
		(
			this.data = this._data
		)

		this.data -- return
	),


	function ensureMenuData =
	(
		this.readDataAlias()

		if not this.isDictionaryValue this.data then
		(
			this.data = Dictionary #string
		)

		this.data -- return
	),


	function ensureQuadData =
	(
		this.readDataAlias()

		if not this.isArrayValue this.data then
		(
			this.data = #()
		)

		this.data -- return
	),


	function addItem category macro_name title:"" =
	(
		this.ensureMenuData()

		item_title = title

		if item_title == "" then
		(
			item_title = macro_name
		)

		this.data[item_title] = #(category, macro_name)

		this -- return
	),


	function addMenu title =
	(
		this.ensureMenuData()

		menu_definition = MenuDefinition_v \
			type:#menu \
			title:title

		this.data[title] = menu_definition.data

		menu_definition -- return
	),


	function addQuad title position:#TopRight =
	(
		this.ensureQuadData()

		quad_definition = MenuDefinition_v \
			type:#quad \
			title:title \
			quad_modifier:this.quad_modifier \
			quad_position:position \
			quad_context_id:this.quad_context_id

		append this.data quad_definition

		quad_definition -- return
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

		if this.data == undefined then
		(
			this.data = Dictionary #string
		)
	)
)


