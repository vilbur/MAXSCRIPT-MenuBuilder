/*
	MenuJsonIO_v 0.38
	Ordered item JSON model: items are arrays, each item has id property.
*/
struct MenuJsonIO_v
(
	version = 0.38,
	source_text = "",
	current_index = 1,

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
	Create guid string.
	Used to migrate old keyed item dictionaries.
	*/
	function createGuidString =
	(
		guid_class = dotNetClass "System.Guid"
		guid_value = guid_class.NewGuid()

		guid_value.ToString() -- return
	),

	/*
	Read whole text file.
	Returns empty string if file is missing.
	*/
	function readTextFile file_path =
	(
		file_text = ""

		if doesFileExist file_path then
		(
			input_file = openFile file_path mode:"r"

			if input_file != undefined then
			(
				while not eof input_file do
				(
					file_text += readLine input_file
					file_text += "\n"
				)

				close input_file
			)
		)

		file_text -- return
	),

	/*
	Write whole text file.
	Creates parent folder.
	*/
	function writeTextFile file_path file_text =
	(
		output_directory = getFilenamePath file_path

		try
		(
			makeDir output_directory all:true
		)
		catch
		(
			ok
		)

		output_file = createFile file_path
		format "%" file_text to:output_file
		close output_file

		file_path -- return
	),

	/*
	Escape string for JSON.
	Minimal JSON escape set.
	*/
	function escapeJsonString source_value =
	(
		source_string = source_value as string

		source_string = substituteString source_string "\\" "\\\\"
		source_string = substituteString source_string "\"" "\\\""
		source_string = substituteString source_string "\t" "\\t"
		source_string = substituteString source_string "\r" "\\r"
		source_string = substituteString source_string "\n" "\\n"

		source_string -- return
	),

	/*
	Make indentation text.
	Uses tabs.
	*/
	function indent level =
	(
		indent_text = ""

		for indent_index = 1 to level do
		(
			indent_text += "\t"
		)

		indent_text -- return
	),

	/*
	Convert bool to JSON.
	Avoids MaxScript True/False capitalization.
	*/
	function boolToJson bool_value =
	(
		json_text = "false"

		if bool_value == true then
		(
			json_text = "true"
		)

		json_text -- return
	),

	/*
	Convert name to JSON string without #.
	Used for enum-like values.
	*/
	function nameToJson name_value =
	(
		name_text = ""

		if name_value != undefined then
		(
			name_text = name_value as string

			if name_text.count > 0 then
			(
				if substring name_text 1 1 == "#" then
				(
					name_text = substring name_text 2 (name_text.count - 1)
				)
			)
		)

		"\"" + this.escapeJsonString name_text + "\"" -- return
	),

	/*
	Convert string to JSON string.
	*/
	function stringToJson string_value =
	(
		"\"" + this.escapeJsonString string_value + "\"" -- return
	),

	/*
	Convert primitive value to JSON.
	Names are stored as strings.
	*/
	function valueToJson value =
	(
		json_text = "null"

		if value == undefined then
		(
			json_text = "null"
		)
		else if classOf value == String then
		(
			json_text = this.stringToJson value
		)
		else if classOf value == Name then
		(
			json_text = this.nameToJson value
		)
		else if value == true or value == false then
		(
			json_text = this.boolToJson value
		)
		else
		(
			json_text = value as string
		)

		json_text -- return
	),

	/*
	Get dictionary value by key.
	Returns default if missing.
	*/
	function getDictValue dictionary_value dictionary_key default_value =
	(
		result_value = default_value

		if this.hasDictValueSafe dictionary_value dictionary_key then
		(
			result_value = dictionary_value[dictionary_key]
		)

		result_value -- return
	),

	/*
	Convert ordered item object to JSON.
	Object contains id + title + either macro fields or items.
	*/
	function itemDataToJson item_data level =
	(
		json_text = ""
		line_indent = this.indent level
		child_indent = this.indent (level + 1)

		item_id = this.getDictValue item_data #id (this.createGuidString())
		item_title = this.getDictValue item_data #title ""

		json_text += "{\n"
		json_text += child_indent + "\"id\": " + this.stringToJson item_id + ",\n"
		json_text += child_indent + "\"title\": " + this.stringToJson item_title

		if this.hasDictValueSafe item_data #items then
		(
			json_text += ",\n"
			json_text += child_indent + "\"items\": " + this.itemsArrayToJson item_data[#items] (level + 1) + "\n"
		)
		else
		(
			item_category = this.getDictValue item_data #category ""
			item_macro = this.getDictValue item_data #macro ""

			json_text += ",\n"
			json_text += child_indent + "\"category\": " + this.stringToJson item_category + ",\n"
			json_text += child_indent + "\"macro\": " + this.stringToJson item_macro + "\n"
		)

		json_text += line_indent + "}"

		json_text -- return
	),

	/*
	Convert ordered item array to JSON.
	Array order is saved directly.
	*/
	function itemsArrayToJson items_array level =
	(
		json_text = ""
		line_indent = this.indent level
		child_indent = this.indent (level + 1)

		json_text += "[\n"

		if this.isArrayValue items_array then
		(
			for item_index = 1 to items_array.count do
			(
				json_text += child_indent + this.itemDataToJson items_array[item_index] (level + 1)

				if item_index < items_array.count then
				(
					json_text += ","
				)

				json_text += "\n"
			)
		)

		json_text += line_indent + "]"

		json_text -- return
	),

	/*
	Convert quad position object to JSON.
	Each quad has ordered items array.
	*/
	function quadDataToJson quad_data level =
	(
		json_text = ""
		line_indent = this.indent level
		child_indent = this.indent (level + 1)

		quad_title = this.getDictValue quad_data #title ""
		quad_position = this.getDictValue quad_data #quad_position undefined
		quad_menu_id = this.getDictValue quad_data #quad_menu_id ""
		quad_items = this.getDictValue quad_data #items #()

		json_text += "{\n"
		json_text += child_indent + "\"title\": " + this.stringToJson quad_title + ",\n"
		json_text += child_indent + "\"quad_position\": " + this.valueToJson quad_position + ",\n"
		json_text += child_indent + "\"quad_menu_id\": " + this.stringToJson quad_menu_id + ",\n"
		json_text += child_indent + "\"items\": " + this.itemsArrayToJson quad_items (level + 1) + "\n"
		json_text += line_indent + "}"

		json_text -- return
	),

	/*
	Convert quad array to JSON.
	Order is preserved.
	*/
	function quadArrayToJson quad_array level =
	(
		json_text = ""
		line_indent = this.indent level
		child_indent = this.indent (level + 1)

		json_text += "[\n"

		if this.isArrayValue quad_array then
		(
			for quad_index = 1 to quad_array.count do
			(
				json_text += child_indent + this.quadDataToJson quad_array[quad_index] (level + 1)

				if quad_index < quad_array.count then
				(
					json_text += ","
				)

				json_text += "\n"
			)
		)

		json_text += line_indent + "]"

		json_text -- return
	),

	/*
	Convert menu root to JSON.
	Menu items are ordered arrays.
	*/
	function menuDataToJson menu_data level =
	(
		json_text = ""
		line_indent = this.indent level
		child_indent = this.indent (level + 1)

		menu_version = this.getDictValue menu_data #version this.version
		menu_id = this.getDictValue menu_data #id ""
		menu_title = this.getDictValue menu_data #title ""
		menu_type = this.getDictValue menu_data #type #menu
		menu_items = this.getDictValue menu_data #items #()
		quad_context_id = this.getDictValue menu_data #quad_context_id ""
		quad_modifier = this.getDictValue menu_data #quad_modifier undefined
		quad_position = this.getDictValue menu_data #quad_position undefined
		quad_menu_id = this.getDictValue menu_data #quad_menu_id ""
		qmnx_clear_directory = this.getDictValue menu_data #qmnx_clear_directory ""
		clear_default_menu = this.getDictValue menu_data #clear_default_menu false
		quad_menus = this.getDictValue menu_data #quad_menus #()

		json_text += "{\n"
		json_text += child_indent + "\"version\": " + (menu_version as string) + ",\n"
		json_text += child_indent + "\"id\": " + this.stringToJson menu_id + ",\n"
		json_text += child_indent + "\"title\": " + this.stringToJson menu_title + ",\n"
		json_text += child_indent + "\"type\": " + this.valueToJson menu_type + ",\n"
		json_text += child_indent + "\"quad_context_id\": " + this.stringToJson quad_context_id + ",\n"
		json_text += child_indent + "\"quad_modifier\": " + this.valueToJson quad_modifier + ",\n"
		json_text += child_indent + "\"quad_position\": " + this.valueToJson quad_position + ",\n"
		json_text += child_indent + "\"quad_menu_id\": " + this.stringToJson quad_menu_id + ",\n"
		json_text += child_indent + "\"qmnx_clear_directory\": " + this.stringToJson qmnx_clear_directory + ",\n"
		json_text += child_indent + "\"clear_default_menu\": " + this.boolToJson clear_default_menu + ",\n"
		json_text += child_indent + "\"items\": " + this.itemsArrayToJson menu_items (level + 1) + ",\n"
		json_text += child_indent + "\"quad_menus\": " + this.quadArrayToJson quad_menus (level + 1) + "\n"
		json_text += line_indent + "}"

		json_text -- return
	),

	/*
	Convert menu array to JSON.
	Usually one root per split file.
	*/
	function menusArrayToJson menus_data_array level =
	(
		json_text = ""
		line_indent = this.indent level
		child_indent = this.indent (level + 1)

		json_text += "[\n"

		if this.isArrayValue menus_data_array then
		(
			for menu_index = 1 to menus_data_array.count do
			(
				json_text += child_indent + this.menuDataToJson menus_data_array[menu_index] (level + 1)

				if menu_index < menus_data_array.count then
				(
					json_text += ","
				)

				json_text += "\n"
			)
		)

		json_text += line_indent + "]"

		json_text -- return
	),

	/*
	Convert menus to root JSON text.
	*/
	function menusDataToJson menus_data_array =
	(
		json_text = ""

		json_text += "{\n"
		json_text += "\t\"version\": " + (this.version as string) + ",\n"
		json_text += "\t\"menus\": " + this.menusArrayToJson menus_data_array 1 + "\n"
		json_text += "}\n"

		json_text -- return
	),

	/*
	Save menus data to JSON file.
	*/
	function saveMenusDataToJsonFile menus_data_array file_path =
	(
		json_text = this.menusDataToJson menus_data_array
		this.writeTextFile file_path json_text

		file_path -- return
	),

	/*
	Get current parser character.
	Returns empty string past end.
	*/
	function getCurrentChar =
	(
		current_char = ""

		if this.current_index <= this.source_text.count then
		(
			current_char = substring this.source_text this.current_index 1
		)

		current_char -- return
	),

	/*
	Advance parser index.
	*/
	function advance count_value =
	(
		this.current_index += count_value

		this.current_index -- return
	),

	/*
	Whitespace test.
	Uses required findString pattern.
	*/
	function isWhiteSpace character_value =
	(
		was_white_space = false

		if character_value != "" then
		(
			was_white_space = (findString " \t\r\n" character_value) != undefined
		)

		was_white_space -- return
	),

	/*
	Skip JSON whitespace.
	*/
	function skipWhiteSpace =
	(
		while this.current_index <= this.source_text.count and this.isWhiteSpace (this.getCurrentChar()) do
		(
			this.advance 1
		)

		this.current_index -- return
	),

	/*
	Parse JSON string.
	Handles simple escapes.
	*/
	function parseJsonString =
	(
		result_text = ""

		this.skipWhiteSpace()

		if this.getCurrentChar() == "\"" then
		(
			this.advance 1

			while this.current_index <= this.source_text.count do
			(
				current_char = this.getCurrentChar()

				if current_char == "\"" then
				(
					this.advance 1
					exit
				)
				else if current_char == "\\" then
				(
					this.advance 1
					escape_char = this.getCurrentChar()

					case escape_char of
					(
						"\"": result_text += "\""
						"\\": result_text += "\\"
						"/": result_text += "/"
						"n": result_text += "\n"
						"r": result_text += "\r"
						"t": result_text += "\t"
						default: result_text += escape_char
					)

					this.advance 1
				)
				else
				(
					result_text += current_char
					this.advance 1
				)
			)
		)

		result_text -- return
	),

	/*
	Parse JSON number or literal.
	*/
	function parseJsonNumberOrLiteral =
	(
		token_text = ""

		this.skipWhiteSpace()

		while this.current_index <= this.source_text.count do
		(
			current_char = this.getCurrentChar()

			if (findString ",]} \t\r\n" current_char) != undefined then
			(
				exit
			)
			else
			(
				token_text += current_char
				this.advance 1
			)
		)

		result_value = token_text

		case token_text of
		(
			"true": result_value = true
			"false": result_value = false
			"null": result_value = undefined
			default:
			(
				try
				(
					if (findString token_text ".") != undefined then
					(
						result_value = token_text as float
					)
					else
					(
						result_value = token_text as integer
					)
				)
				catch
				(
					result_value = token_text
				)
			)
		)

		result_value -- return
	),

	/*
	Parse JSON array.
	*/
	function parseJsonArray =
	(
		result_array = #()

		this.skipWhiteSpace()

		if this.getCurrentChar() == "[" then
		(
			this.advance 1
			this.skipWhiteSpace()

			while this.current_index <= this.source_text.count do
			(
				this.skipWhiteSpace()

				if this.getCurrentChar() == "]" then
				(
					this.advance 1
					exit
				)

				append result_array (this.parseJsonValue())
				this.skipWhiteSpace()

				if this.getCurrentChar() == "," then
				(
					this.advance 1
				)
			)
		)

		result_array -- return
	),

	/*
	Parse JSON object.
	*/
	function parseJsonObject =
	(
		result_object = Dictionary #string

		this.skipWhiteSpace()

		if this.getCurrentChar() == "{" then
		(
			this.advance 1
			this.skipWhiteSpace()

			while this.current_index <= this.source_text.count do
			(
				this.skipWhiteSpace()

				if this.getCurrentChar() == "}" then
				(
					this.advance 1
					exit
				)

				object_key = this.parseJsonString()
				this.skipWhiteSpace()

				if this.getCurrentChar() == ":" then
				(
					this.advance 1
				)

				object_value = this.parseJsonValue()
				result_object[object_key] = object_value

				this.skipWhiteSpace()

				if this.getCurrentChar() == "," then
				(
					this.advance 1
				)
			)
		)

		result_object -- return
	),

	/*
	Parse JSON value.
	*/
	function parseJsonValue =
	(
		result_value = undefined

		this.skipWhiteSpace()
		current_char = this.getCurrentChar()

		if current_char == "{" then
		(
			result_value = this.parseJsonObject()
		)
		else if current_char == "[" then
		(
			result_value = this.parseJsonArray()
		)
		else if current_char == "\"" then
		(
			result_value = this.parseJsonString()
		)
		else
		(
			result_value = this.parseJsonNumberOrLiteral()
		)

		result_value -- return
	),

	/*
	Parse JSON text.
	*/
	function parseJsonText json_text =
	(
		this.source_text = json_text
		this.current_index = 1

		this.parseJsonValue() -- return
	),

	/*
	Get parsed JSON dictionary value.
	*/
	function getJsonValue json_object json_key default_value =
	(
		result_value = default_value

		if this.isDictionaryValue json_object then
		(
			if this.hasDictValueSafe json_object json_key then
			(
				result_value = json_object[json_key]
			)
		)

		result_value -- return
	),

	/*
	Convert string to Name value.
	*/
	function stringToName value default_name =
	(
		result_name = default_name

		if value != undefined then
		(
			try
			(
				value_text = value as string

				if value_text != "" and value_text != "undefined" then
				(
					if substring value_text 1 1 == "#" then
					(
						value_text = substring value_text 2 (value_text.count - 1)
					)

					result_name = execute ("#" + value_text)
				)
			)
			catch
			(
				result_name = default_name
			)
		)

		result_name -- return
	),

	/*
	Convert JSON item object to saved item.
	*/
	function jsonItemToSavedItem json_item fallback_id:undefined =
	(
		item_data = Dictionary #name
		item_id = this.getJsonValue json_item "id" fallback_id

		if item_id == undefined then
		(
			item_id = this.createGuidString()
		)

		item_data[#id] = item_id
		item_data[#title] = this.getJsonValue json_item "title" ""

		if this.hasDictValueSafe json_item "items" then
		(
			item_data[#items] = this.jsonItemsToSavedItems (this.getJsonValue json_item "items" #())
		)
		else
		(
			item_data[#category] = this.getJsonValue json_item "category" ""
			item_data[#macro] = this.getJsonValue json_item "macro" ""
		)

		item_data -- return
	),

	/*
	Convert parsed JSON items to ordered saved array.
	Accepts new array and old keyed dictionary for migration.
	*/
	function jsonItemsToSavedItems json_items =
	(
		saved_items = #()

		if this.isArrayValue json_items then
		(
			for json_item in json_items do
			(
				append saved_items (this.jsonItemToSavedItem json_item)
			)
		)
		else if this.isDictionaryValue json_items then
		(
			item_keys = GetDictKeys json_items

			for item_key in item_keys do
			(
				append saved_items (this.jsonItemToSavedItem json_items[item_key] fallback_id:(item_key as string))
			)
		)

		saved_items -- return
	),

	/*
	Convert parsed JSON quad object to saved quad.
	*/
	function jsonQuadToSavedQuad json_quad =
	(
		quad_data = Dictionary #name

		quad_data[#title] = this.getJsonValue json_quad "title" ""
		quad_data[#quad_position] = this.stringToName (this.getJsonValue json_quad "quad_position" undefined) undefined
		quad_data[#quad_menu_id] = this.getJsonValue json_quad "quad_menu_id" ""
		quad_data[#items] = this.jsonItemsToSavedItems (this.getJsonValue json_quad "items" #())

		quad_data -- return
	),

	/*
	Convert parsed JSON quad array to saved quad array.
	*/
	function jsonQuadArrayToSavedQuadArray json_quad_array =
	(
		quad_array = #()

		if this.isArrayValue json_quad_array then
		(
			for json_quad in json_quad_array do
			(
				append quad_array (this.jsonQuadToSavedQuad json_quad)
			)
		)

		quad_array -- return
	),

	/*
	Convert parsed JSON menu object to saved menu.
	*/
	function jsonMenuToSavedMenu json_menu =
	(
		menu_data = Dictionary #name

		menu_data[#version] = this.getJsonValue json_menu "version" this.version
		menu_data[#id] = this.getJsonValue json_menu "id" (this.createGuidString())
		menu_data[#title] = this.getJsonValue json_menu "title" ""
		menu_data[#type] = this.stringToName (this.getJsonValue json_menu "type" "menu") #menu
		menu_data[#quad_context_id] = this.getJsonValue json_menu "quad_context_id" ""
		menu_data[#quad_modifier] = this.stringToName (this.getJsonValue json_menu "quad_modifier" undefined) undefined
		menu_data[#quad_position] = this.stringToName (this.getJsonValue json_menu "quad_position" undefined) undefined
		menu_data[#quad_menu_id] = this.getJsonValue json_menu "quad_menu_id" ""
		menu_data[#qmnx_clear_directory] = this.getJsonValue json_menu "qmnx_clear_directory" ""
		menu_data[#clear_default_menu] = this.getJsonValue json_menu "clear_default_menu" false
		menu_data[#items] = this.jsonItemsToSavedItems (this.getJsonValue json_menu "items" #())
		menu_data[#quad_menus] = this.jsonQuadArrayToSavedQuadArray (this.getJsonValue json_menu "quad_menus" #())

		menu_data -- return
	),

	/*
	Convert parsed root object to menu data array.
	*/
	function jsonRootToMenuData json_root =
	(
		menus_data = #()

		if this.isDictionaryValue json_root then
		(
			json_menus = this.getJsonValue json_root "menus" #()

			if this.isArrayValue json_menus then
			(
				for json_menu in json_menus do
				(
					append menus_data (this.jsonMenuToSavedMenu json_menu)
				)
			)
		)
		else if this.isArrayValue json_root then
		(
			for json_menu in json_root do
			(
				append menus_data (this.jsonMenuToSavedMenu json_menu)
			)
		)

		menus_data -- return
	),

	/*
	Load menu data from JSON file.
	Returns array of saved menu dictionaries.
	*/
	function loadMenusDataFromJsonFile file_path =
	(
		menus_data = #()

		if doesFileExist file_path then
		(
			json_text = this.readTextFile file_path

			if json_text != "" then
			(
				try
				(
					json_root = this.parseJsonText json_text
					menus_data = this.jsonRootToMenuData json_root
				)
				catch
				(
					format "MenuJsonIO_v.loadMenusDataFromJsonFile failed:\n%\n" file_path
					menus_data = #()
				)
			)
		)

		menus_data -- return
	)
)
