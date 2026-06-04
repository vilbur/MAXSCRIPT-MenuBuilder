filein( getFilenamePath(getSourceFileName()) + "/../include-menus.ms" )	--"./../include-menus.ms"

/*


*/ 
struct MenuBuildManager_v
(
	version = 0.30,
	menus_data = #(),
	wait_for_build = #(),
	saved_menus_data = #(),
	data_file_name = "MenuRebuilder_data.json",
	data_folder_name = "MenuRebuilder_data",
	menus_folder_name = "menus",
	quads_folder_name = "quads",
	split_json_enabled = true,
	split_data_root_directory = "",
	custom_menu_root_title = "_Custom-Menus",
	custom_menu_root_id = "4a93a53d-8cf7-4d16-b217-8fe6c2b9d6f1",
	main_menu_bar_title = "Main Menu Bar",
	startup_file_name = "MenuRebuilder_startup.ms",
	data_file_path = "",
	startup_file_path = "",
	rebuilder_file_path = "",
	qmnx_clear_directory = "",
	auto_register_callback = true,
	merge_existing_data = true,
	callback_id = #menuBuildManagerCuiRegisterMenus,
	quad_callback_id = #menuBuildManagerCuiRegisterQuadMenus,


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


	function getDefaultStartupDirectory =
	(
		startup_directory = ""

		try
		(
			startup_directory = getDir #userStartupScripts
		)
		catch
		(
			startup_directory = getDir #userScripts + "\\startup"
		)

		try
		(
			makeDir startup_directory all:true
		)
		catch
		(
			ok
		)

		startup_directory -- return
	),


	function getCurrentSourceFilePath =
	(
		source_file_path = ""

		try
		(
			source_file_path = getSourceFileName()
		)
		catch
		(
			source_file_path = ""
		)

		source_file_path -- return
	),


	function normalizeMenuType type_value =
	(
		normalized_type = #menu
		type_text = type_value as string

		if type_text == "#quad" then normalized_type = #quad
		if type_text == "quad" then normalized_type = #quad
		if type_text == "#QUAD" then normalized_type = #quad
		if type_text == "QUAD" then normalized_type = #quad

		if type_text == "#both" then normalized_type = #both
		if type_text == "both" then normalized_type = #both
		if type_text == "#BOTH" then normalized_type = #both
		if type_text == "BOTH" then normalized_type = #both

		normalized_type -- return
	),


	function normalizeQuadModifier modifier_value =
	(
		menu_rebuilder = MenuRebuilder_v()
		menu_rebuilder.normalizeQuadModifier modifier_value -- return
	),


	function getDefinitionData menu_definition =
	(
		definition_data = menu_definition.data

		if menu_definition._data != undefined then
		(
			definition_data = menu_definition._data
		)

		definition_data -- return
	),


	function createSavedMacroItemData item_title macro_category macro_name =
	(
		item_data = Dictionary #name

		item_data[#title] = item_title
		item_data[#category] = macro_category
		item_data[#macro] = macro_name

		item_data -- return
	),


	function createSavedSubMenuData submenu_title submenu_items =
	(
		submenu_data = Dictionary #name

		submenu_data[#title] = submenu_title
		submenu_data[#items] = submenu_items

		submenu_data -- return
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
			was_found = this.hasDictValueSafe item_data #category

			if was_found then
			(
				was_found = this.hasDictValueSafe item_data #macro
			)
		)

		was_found -- return
	),


	function isSavedItemData item_data =
	(
		was_found = false

		if this.isDictionaryValue item_data then
		(
			was_found = this.hasDictValueSafe item_data #title

			if was_found then
			(
				if this.isSubMenuData item_data then
				(
					was_found = true
				)
				else
				(
					was_found = this.isMacroItemData item_data
				)
			)
		)

		was_found -- return
	),


	function isSavedItemsDictionary dictionary_value =
	(
		was_found = false

		if this.isDictionaryValue dictionary_value then
		(
			dictionary_keys = GetDictKeys dictionary_value

			if dictionary_keys.count == 0 then
			(
				was_found = true
			)
			else
			(
				first_item_data = dictionary_value[dictionary_keys[1]]
				was_found = this.isSavedItemData first_item_data
			)
		)

		was_found -- return
	),


	function convertSourceItemsToSavedItems source_items =
	(
		saved_items = Dictionary #string

		if this.isDictionaryValue source_items then
		(
			source_key_array = GetDictKeys source_items

			for source_title in source_key_array do
			(
				source_value = source_items[source_title]
				saved_guid = this.createGuidString()

				if this.isDictionaryValue source_value then
				(
					submenu_items = this.convertSourceItemsToSavedItems source_value
					saved_items[saved_guid] = this.createSavedSubMenuData source_title submenu_items
				)
				else if classOf source_value == Array then
				(
					if source_value.count >= 2 then
					(
						saved_items[saved_guid] = this.createSavedMacroItemData source_title source_value[1] source_value[2]
					)
				)
			)
		)

		saved_items -- return
	),


	function normalizeMenuItems items_value =
	(
		normalized_items = Dictionary #string

		if this.isDictionaryValue items_value then
		(
			item_keys = GetDictKeys items_value

			for item_key in item_keys do
			(
				item_value = items_value[item_key]

				if this.isSavedItemData item_value then
				(
					normalized_items[item_key] = item_value
				)
				else if this.isDictionaryValue item_value then
				(
					submenu_items = this.normalizeMenuItems item_value
					saved_guid = this.createGuidString()
					normalized_items[saved_guid] = this.createSavedSubMenuData item_key submenu_items
				)
				else if classOf item_value == Array then
				(
					if item_value.count >= 2 then
					(
						saved_guid = this.createGuidString()
						normalized_items[saved_guid] = this.createSavedMacroItemData item_key item_value[1] item_value[2]
					)
				)
			)
		)

		normalized_items -- return
	),

	function createSavedRootData menu_definition definition_type =
	(
		root_data = undefined

		if menu_definition.title == "" then
		(
			format "MenuBuildManager_v.createSavedRootData skipped. Missing menu title.\n"
		)
		else
		(
			clear_flag = false

			if menu_definition.clear_defaul_menu then
			(
				clear_flag = true
			)

			if menu_definition.clear_default_menu then
			(
				clear_flag = true
			)

			root_data = Dictionary #name

			root_data[#version] = this.version

			if menu_definition.id != "" then
			(
				root_data[#id] = menu_definition.id
			)
			else
			(
				root_data[#id] = this.createGuidString()
			)

			root_data[#title] = menu_definition.title
			root_data[#type] = definition_type
			root_data[#items] = Dictionary #string
			root_data[#quad_context_id] = menu_definition.quad_context_id
			root_data[#quad_modifier] = this.normalizeQuadModifier menu_definition.quad_modifier

			if definition_type == #menu then
			(
				root_data[#quad_position] = undefined
			)
			else
			(
				root_data[#quad_position] = menu_definition.quad_position
			)

			if menu_definition.quad_menu_id != "" then
			(
				root_data[#quad_menu_id] = menu_definition.quad_menu_id
			)
			else
			(
				root_data[#quad_menu_id] = this.createGuidString()
			)
			if menu_definition.qmnx_clear_directory != "" then
			(
				root_data[#qmnx_clear_directory] = menu_definition.qmnx_clear_directory
			)
			else
			(
				root_data[#qmnx_clear_directory] = this.qmnx_clear_directory
			)
			root_data[#clear_defaul_menu] = clear_flag
			root_data[#quad_menus] = #()
		)

		root_data -- return
	),

	function buildSavedQuadDataFromDefinition quad_definition =
	(
		quad_source_data = this.getDefinitionData quad_definition
		quad_data = Dictionary #name

		quad_data[#title] = quad_definition.title
		quad_data[#quad_position] = quad_definition.quad_position

		if quad_definition.quad_menu_id != "" then
		(
			quad_data[#quad_menu_id] = quad_definition.quad_menu_id
		)
		else
		(
			quad_data[#quad_menu_id] = this.createGuidString()
		)

		quad_data[#items] = this.normalizeMenuItems quad_source_data

		quad_data -- return
	),


	function buildSavedQuadRootDataFromDefinition menu_definition =
	(
		root_data = this.createSavedRootData menu_definition #quad

		if root_data != undefined then
		(
			root_data[#items] = Dictionary #string
			root_data[#quad_menus] = #()

			quad_definition_array = this.getDefinitionData menu_definition

			for quad_definition in quad_definition_array do
			(
				append root_data[#quad_menus] (this.buildSavedQuadDataFromDefinition quad_definition)
			)
		)

		root_data -- return
	),


	function buildSavedSingleRootDataFromDefinition menu_definition definition_type =
	(
		root_data = this.createSavedRootData menu_definition definition_type

		if root_data != undefined then
		(
			definition_data = this.getDefinitionData menu_definition

			root_data[#items] = this.normalizeMenuItems definition_data
			root_data[#quad_menus] = #()
		)

		root_data -- return
	),


	function buildSavedMenuDataFromDefinition menu_definition =
	(
		menu_data = undefined
		definition_type_value = menu_definition.type
		definition_type = this.normalizeMenuType definition_type_value
		definition_data = this.getDefinitionData menu_definition

		if definition_type == #quad then
		(
			if this.isArrayValue definition_data then
			(
				menu_data = this.buildSavedQuadRootDataFromDefinition menu_definition
			)
			else
			(
				menu_data = this.buildSavedSingleRootDataFromDefinition menu_definition #quad
			)
		)
		else
		(
			menu_data = this.buildSavedSingleRootDataFromDefinition menu_definition definition_type
		)

		if menu_data != undefined then
		(
			menu_data[#version] = this.version
		)

		menu_data -- return
	),


	function buildSavedMenusData =
	(
		this.saved_menus_data = #()

		for menu_definition in this.menus_data do
		(
			menu_data = this.buildSavedMenuDataFromDefinition menu_definition

			if menu_data != undefined then
			(
				append this.saved_menus_data menu_data
			)
		)

		this.saved_menus_data = this.groupMenusUnderCustomMenuRoot this.saved_menus_data

		this.saved_menus_data -- return
	),


	function loadSavedMenusDataFromJson =
	(
		menus_data_array = #()

		if this.split_json_enabled then
		(
			menus_data_array = this.loadMenusDataFromSplitJson()

			if menus_data_array.count == 0 then
			(
				json_io = MenuJsonIO_v()
				menus_data_array = json_io.loadMenusDataFromJsonFile this.data_file_path
			)
		)
		else
		(
			json_io = MenuJsonIO_v()
			menus_data_array = json_io.loadMenusDataFromJsonFile this.data_file_path
		)

		menus_data_array = this.groupMenusUnderCustomMenuRoot menus_data_array

		menus_data_array -- return
	),

	function writeSavedMenusDataToJson menus_data_array =
	(
		if this.split_json_enabled then
		(
			this.saveMenusDataToSplitJson menus_data_array

			if doesFileExist this.data_file_path then
			(
				try
				(
					deleteFile this.data_file_path
					format "Removed stale single JSON file:\n%\n" this.data_file_path
				)
				catch
				(
					format "Could not remove stale single JSON file:\n%\n" this.data_file_path
				)
			)
		)
		else
		(
			json_io = MenuJsonIO_v()
			json_io.saveMenusDataToJsonFile menus_data_array this.data_file_path
		)

		this.data_file_path -- return
	),


	function getSplitDataRootDirectory =
	(
		root_directory = this.split_data_root_directory

		if root_directory == "" then
		(
			if this.data_file_path != "" then
			(
				root_directory = (getFilenamePath this.data_file_path) + this.data_folder_name
			)
			else
			(
				root_directory = (getDir #userScripts) + "\\" + this.data_folder_name
			)
		)

		root_directory -- return
	),


	function getSplitMenusDirectory =
	(
		((this.getSplitDataRootDirectory()) + "\\" + this.menus_folder_name) -- return
	),


	function getSplitQuadsDirectory =
	(
		((this.getSplitDataRootDirectory()) + "\\" + this.quads_folder_name) -- return
	),


	function ensureSplitJsonDirectories =
	(
		try
		(
			makeDir (this.getSplitDataRootDirectory()) all:true
			makeDir (this.getSplitMenusDirectory()) all:true
			makeDir (this.getSplitQuadsDirectory()) all:true
		)
		catch
		(
			format "MenuBuildManager_v.ensureSplitJsonDirectories failed.\n"
		)

		ok -- return
	),


	function sanitizeJsonFileName source_text =
	(
		file_name = source_text as string

		file_name = substituteString file_name "\\" "_"
		file_name = substituteString file_name "/" "_"
		file_name = substituteString file_name ":" "_"
		file_name = substituteString file_name "*" "_"
		file_name = substituteString file_name "?" "_"
		file_name = substituteString file_name "\"" "_"
		file_name = substituteString file_name "<" "_"
		file_name = substituteString file_name ">" "_"
		file_name = substituteString file_name "|" "_"

		if file_name == "" then
		(
			file_name = "Untitled_Menu"
		)

		file_name -- return
	),


	function getSplitJsonFilePath menu_data =
	(
		menu_title = this.getSavedMenuTitle menu_data
		menu_type = this.getSavedMenuType menu_data
		file_name = this.sanitizeJsonFileName menu_title
		file_path = ""

		if menu_type == #quad then
		(
			file_path = (this.getSplitQuadsDirectory()) + "\\" + file_name + ".json"
		)
		else
		(
			file_path = (this.getSplitMenusDirectory()) + "\\" + file_name + ".json"
		)

		file_path -- return
	),


	function deleteJsonFilesInDirectory directory_path =
	(
		json_files = getFiles (directory_path + "\\*.json")

		for json_file in json_files do
		(
			try
			(
				deleteFile json_file
			)
			catch
			(
				format "Could not delete old json file: %\n" json_file
			)
		)

		json_files.count -- return
	),


	function clearSplitJsonFiles =
	(
		this.ensureSplitJsonDirectories()
		deleted_count = 0
		deleted_count += this.deleteJsonFilesInDirectory (this.getSplitMenusDirectory())
		deleted_count += this.deleteJsonFilesInDirectory (this.getSplitQuadsDirectory())

		deleted_count -- return
	),


	function saveMenusDataToSplitJson menus_data_array =
	(
		timer_save_split = timeStamp()
		json_io = MenuJsonIO_v()
		menus_data_array = this.groupMenusUnderCustomMenuRoot menus_data_array

		this.ensureSplitJsonDirectories()
		this.clearSplitJsonFiles()

		for menu_data in menus_data_array do
		(
			if this.isValidSavedMenuData menu_data then
			(
				split_file_path = this.getSplitJsonFilePath menu_data
				json_io.saveMenusDataToJsonFile #(menu_data) split_file_path
			)
		)

		format "SPLIT JSON SAVE: % files in % ms\n" menus_data_array.count ((timeStamp()) - timer_save_split)

		this.getSplitDataRootDirectory() -- return
	),


	function loadMenusDataFromSplitJson =
	(
		timer_load_split = timeStamp()
		json_io = MenuJsonIO_v()
		menus_data_array = #()

		this.ensureSplitJsonDirectories()

		json_files = #()
		join json_files (getFiles ((this.getSplitMenusDirectory()) + "\\*.json"))
		join json_files (getFiles ((this.getSplitQuadsDirectory()) + "\\*.json"))

		for json_file in json_files do
		(
			file_menus_data = json_io.loadMenusDataFromJsonFile json_file

			for menu_data in file_menus_data do
			(
				append menus_data_array menu_data
			)
		)

		format "SPLIT JSON LOAD: % files, % menus in % ms\n" json_files.count menus_data_array.count ((timeStamp()) - timer_load_split)

		menus_data_array -- return
	),

	function clearJsonFile =
	(
		this.saved_menus_data = #()

		if this.split_json_enabled then
		(
			this.clearSplitJsonFiles()
		)

		this.writeSavedMenusDataToJson this.saved_menus_data

		format "Menu JSON file cleared:\n%\n" this.data_file_path

		this.saved_menus_data -- return
	),


	function deleteAllMenusFromJson =
	(
		this.clearJsonFile() -- return
	),


	function getSavedMenuType menu_data =
	(
		saved_type = #menu

		if this.isDictionaryValue menu_data then
		(
			if this.hasDictValueSafe menu_data #type then
			(
				saved_type = this.normalizeMenuType menu_data[#type]
			)
		)

		saved_type -- return
	),


	function getSavedMenuTitle menu_data =
	(
		menu_title = ""

		if this.isDictionaryValue menu_data then
		(
			if this.hasDictValueSafe menu_data #title then
			(
				menu_title = menu_data[#title]
			)
		)

		menu_title -- return
	),


	function getSavedQuadModifier menu_data =
	(
		quad_modifier = undefined

		if this.isDictionaryValue menu_data then
		(
			if this.hasDictValueSafe menu_data #quad_modifier then
			(
				quad_modifier = this.normalizeQuadModifier menu_data[#quad_modifier]
			)
		)

		quad_modifier -- return
	),


	function getSavedQmnxClearDirectory menu_data =
	(
		clear_directory = ""

		if this.isDictionaryValue menu_data then
		(
			if this.hasDictValueSafe menu_data #qmnx_clear_directory then
			(
				clear_directory = menu_data[#qmnx_clear_directory]
			)
		)

		clear_directory -- return
	),


	function getSavedClearDefaulMenu menu_data =
	(
		clear_flag = false

		if this.isDictionaryValue menu_data then
		(
			if this.hasDictValueSafe menu_data #clear_defaul_menu then
			(
				clear_flag = menu_data[#clear_defaul_menu]
			)
		)

		clear_flag -- return
	),


	function findMenuDefinitionByTitle menu_title =
	(
		found_definition = undefined

		for menu_definition in this.menus_data while found_definition == undefined do
		(
			if menu_definition.title == menu_title then
			(
				found_definition = menu_definition
			)
		)

		found_definition -- return
	),


	function findSavedMenuDataByTitle menu_title =
	(
		found_menu_data = undefined
		custom_root_data = undefined
		json_menus_data = this.loadSavedMenusDataFromJson()

		for menu_data in json_menus_data while found_menu_data == undefined do
		(
			if this.isCustomMenuRootData menu_data then
			(
				custom_root_data = menu_data
			)

			if this.getSavedMenuTitle menu_data == menu_title then
			(
				found_menu_data = menu_data
			)
		)

		if found_menu_data == undefined then
		(
			found_menu_data = this.findSavedChildMenuDataInCustomRoot menu_title custom_root_data
		)

		found_menu_data -- return
	),

	function createQuadDefinitionFromSavedQuadData quad_data root_menu_data =
	(
		quad_definition = MenuDefinition_v \
			type:#quad \
			title:quad_data[#title] \
			id:"" \
			quad_menu_id:quad_data[#quad_menu_id] \
			data:quad_data[#items] \
			quad_modifier:(this.getSavedQuadModifier root_menu_data) \
			quad_position:quad_data[#quad_position] \
			quad_context_id:root_menu_data[#quad_context_id] \
			qmnx_clear_directory:(this.getSavedQmnxClearDirectory root_menu_data) \
			clear_defaul_menu:(this.getSavedClearDefaulMenu root_menu_data)

		quad_definition -- return
	),


	function createMenuDefinitionFromSavedMenuData menu_data =
	(
		definition_type = this.getSavedMenuType menu_data
		definition_title = this.getSavedMenuTitle menu_data
		definition_clear_flag = this.getSavedClearDefaulMenu menu_data

		menu_definition = MenuDefinition_v \
			type:definition_type \
			title:definition_title \
			id:menu_data[#id] \
			quad_menu_id:menu_data[#quad_menu_id] \
			quad_modifier:(this.getSavedQuadModifier menu_data) \
			quad_position:menu_data[#quad_position] \
			quad_context_id:menu_data[#quad_context_id] \
			qmnx_clear_directory:(this.getSavedQmnxClearDirectory menu_data) \
			clear_defaul_menu:definition_clear_flag

		if definition_type == #quad then
		(
			if this.hasDictValueSafe menu_data #quad_menus then
			(
				quad_menus = menu_data[#quad_menus]

				if classOf quad_menus == Array and quad_menus.count > 0 then
				(
					menu_definition.data = #()

					for quad_data in quad_menus do
					(
						append menu_definition.data (this.createQuadDefinitionFromSavedQuadData quad_data menu_data)
					)
				)
				else
				(
					menu_definition.data = menu_data[#items]
				)
			)
			else
			(
				menu_definition.data = menu_data[#items]
			)
		)
		else
		(
			menu_definition.data = menu_data[#items]
		)

		menu_definition -- return
	),


	function menu title type:#menu clear_defaul_menu:false clear_default_menu:false =
	(
		menu_definition = this.findMenuDefinitionByTitle title

		if menu_definition == undefined then
		(
			saved_menu_data = this.findSavedMenuDataByTitle title

			if saved_menu_data != undefined then
			(
				menu_definition = this.createMenuDefinitionFromSavedMenuData saved_menu_data

				if (clear_defaul_menu or clear_default_menu) then
				(
					menu_definition.setClearDefaulMenu true
				)
			)
			else
			(
				definition_type = this.normalizeMenuType type
				definition_quad_modifier = undefined
				definition_quad_position = undefined

				if title == "Default Viewport Quad" then
				(
					definition_type = #quad
					definition_quad_modifier = #nonePressed
					definition_quad_position = #TopRight
				)

				menu_definition = MenuDefinition_v \
					type:definition_type \
					title:title \
					quad_modifier:definition_quad_modifier \
					quad_position:definition_quad_position \
					qmnx_clear_directory:this.qmnx_clear_directory \
					clear_defaul_menu:clear_defaul_menu \
					clear_default_menu:clear_default_menu
			)

			append this.menus_data menu_definition
		)

		menu_definition -- return
	),


	function isValidSavedMenuData menu_data =
	(
		this.getSavedMenuTitle menu_data != "" -- return
	),


	function isMenuCallbackData menu_data =
	(
		saved_type = this.getSavedMenuType menu_data

		if not this.isValidSavedMenuData menu_data then
		(
			false -- return
		)
		else if saved_type == #menu then
		(
			true -- return
		)
		else if saved_type == #both then
		(
			true -- return
		)
		else
		(
			false -- return
		)
	),


	function isQuadCallbackData menu_data =
	(
		saved_type = this.getSavedMenuType menu_data

		if not this.isValidSavedMenuData menu_data then
		(
			false -- return
		)
		else if saved_type == #quad then
		(
			true -- return
		)
		else if saved_type == #both then
		(
			true -- return
		)
		else
		(
			false -- return
		)
	),


	function isDefaultQuadInjectionData menu_data =
	(
		was_found = false

		if this.isQuadCallbackData menu_data then
		(
			if this.getSavedQuadModifier menu_data == #nonePressed then
			(
				was_found = true
			)
		)

		was_found -- return
	),


	function getMenuDataSignature menu_data =
	(
		signature = ""

		if this.isValidSavedMenuData menu_data then
		(
			menu_type_text = this.getSavedMenuType menu_data as string
			menu_title_text = this.getSavedMenuTitle menu_data

			signature = menu_type_text + "|" + menu_title_text
		)

		signature -- return
	),


	function isStringInArray string_array string_value =
	(
		was_found = false

		for item_string in string_array while not was_found do
		(
			if item_string == string_value then
			(
				was_found = true
			)
		)

		was_found -- return
	),


	function getSavedItemTitle item_data =
	(
		item_title = ""

		if this.isDictionaryValue item_data then
		(
			if this.hasDictValueSafe item_data #title then
			(
				item_title = item_data[#title]
			)
		)

		item_title -- return
	),


	function findSavedItemKeyByTitle saved_items item_title =
	(
		found_key = undefined

		if this.isDictionaryValue saved_items then
		(
			saved_item_keys = GetDictKeys saved_items

			for saved_item_key in saved_item_keys while found_key == undefined do
			(
				saved_item_data = saved_items[saved_item_key]

				if this.getSavedItemTitle saved_item_data == item_title then
				(
					found_key = saved_item_key
				)
			)
		)

		found_key -- return
	),


	function isCustomMenuRootTitle menu_title =
	(
		(menu_title == this.custom_menu_root_title) -- return
	),


	function isMainMenuBarTitle menu_title =
	(
		(menu_title == this.main_menu_bar_title) -- return
	),


	function shouldNestMenuUnderCustomRoot menu_data =
	(
		should_nest = false

		if this.getSavedMenuType menu_data == #menu then
		(
			menu_title = this.getSavedMenuTitle menu_data

			if menu_title != "" then
			(
				if not this.isCustomMenuRootTitle menu_title then
				(
					if not this.isMainMenuBarTitle menu_title then
					(
						should_nest = true
					)
				)
			)
		)

		should_nest -- return
	),


	function createCustomMenuRootData =
	(
		root_data = Dictionary #name

		root_data[#version] = this.version
		root_data[#id] = this.custom_menu_root_id
		root_data[#title] = this.custom_menu_root_title
		root_data[#type] = #menu
		root_data[#items] = Dictionary #string
		root_data[#quad_context_id] = ""
		root_data[#quad_modifier] = undefined
		root_data[#quad_position] = undefined
		root_data[#quad_menu_id] = ""
		root_data[#qmnx_clear_directory] = this.qmnx_clear_directory
		root_data[#clear_defaul_menu] = false
		root_data[#quad_menus] = #()

		root_data -- return
	),


	function isCustomMenuRootData menu_data =
	(
		was_found = false

		if this.isDictionaryValue menu_data then
		(
			if this.getSavedMenuType menu_data == #menu then
			(
				if this.getSavedMenuTitle menu_data == this.custom_menu_root_title then
				(
					was_found = true
				)
			)
		)

		was_found -- return
	),


	function createSubMenuItemDataFromRootMenuData menu_data =
	(
		submenu_data = Dictionary #name

		submenu_data[#title] = menu_data[#title]
		submenu_data[#items] = menu_data[#items]

		submenu_data -- return
	),


	function addMenuDataToCustomMenuRoot custom_root_data menu_data =
	(
		custom_items = custom_root_data[#items]
		menu_title = this.getSavedMenuTitle menu_data
		menu_id = ""

		if this.hasDictValueSafe menu_data #id then
		(
			menu_id = menu_data[#id]
		)

		if menu_id == undefined or menu_id == "" then
		(
			menu_id = this.createGuidString()
		)

		new_submenu_data = this.createSubMenuItemDataFromRootMenuData menu_data
		existing_key = this.findSavedItemKeyByTitle custom_items menu_title

		if existing_key != undefined then
		(
			existing_submenu_data = custom_items[existing_key]
			custom_items[existing_key] = this.mergeSavedItemData existing_submenu_data new_submenu_data
		)
		else
		(
			custom_items[menu_id] = new_submenu_data
		)

		custom_root_data[#items] = custom_items

		custom_root_data -- return
	),


	function getSavedItemSortTitle item_data =
	(
		item_title = this.getSavedItemTitle item_data
		sort_title = item_title

		try
		(
			sort_title = toLower item_title
		)
		catch
		(
			sort_title = item_title
		)

		sort_title -- return
	),


	function sortSavedItemKeysByTitle saved_items =
	(
		sorted_keys = #()

		if this.isDictionaryValue saved_items then
		(
			saved_item_keys = GetDictKeys saved_items

			for saved_item_key in saved_item_keys do
			(
				item_data = saved_items[saved_item_key]
				item_sort_title = this.getSavedItemSortTitle item_data
				insert_index = sorted_keys.count + 1

				for sorted_index = 1 to sorted_keys.count while insert_index == sorted_keys.count + 1 do
				(
					sorted_item_data = saved_items[sorted_keys[sorted_index]]
					sorted_item_title = this.getSavedItemSortTitle sorted_item_data

					if item_sort_title < sorted_item_title then
					(
						insert_index = sorted_index
					)
				)

				insertItem saved_item_key sorted_keys insert_index
			)
		)

		sorted_keys -- return
	),


	function sortSavedItemsByTitle saved_items =
	(
		sorted_items = Dictionary #string

		if this.isDictionaryValue saved_items then
		(
			sorted_keys = this.sortSavedItemKeysByTitle saved_items

			for sorted_key in sorted_keys do
			(
				sorted_items[sorted_key] = saved_items[sorted_key]
			)
		)

		sorted_items -- return
	),


	function sortCustomMenuRootItems custom_root_data =
	(
		if this.hasDictValueSafe custom_root_data #items then
		(
			custom_root_data[#items] = this.sortSavedItemsByTitle custom_root_data[#items]
		)

		custom_root_data -- return
	),


	function groupMenusUnderCustomMenuRoot menus_data_array =
	(
		grouped_menus_data = #()
		custom_root_data = undefined

		for menu_data in menus_data_array do
		(
			if this.isCustomMenuRootData menu_data then
			(
				if custom_root_data == undefined then
				(
					custom_root_data = menu_data
				)
				else
				(
					custom_root_data = this.mergeSavedMenuData custom_root_data menu_data
				)
			)
		)

		for menu_data in menus_data_array do
		(
			if this.shouldNestMenuUnderCustomRoot menu_data then
			(
				if custom_root_data == undefined then
				(
					custom_root_data = this.createCustomMenuRootData()
				)

				custom_root_data = this.addMenuDataToCustomMenuRoot custom_root_data menu_data
			)
			else
			(
				if not this.isCustomMenuRootData menu_data then
				(
					append grouped_menus_data menu_data
				)
			)
		)

		if custom_root_data != undefined then
		(
			custom_root_data = this.sortCustomMenuRootItems custom_root_data
			append grouped_menus_data custom_root_data
		)

		grouped_menus_data -- return
	),


	function findSavedChildMenuDataInCustomRoot menu_title custom_root_data =
	(
		found_menu_data = undefined

		if custom_root_data != undefined then
		(
			if this.hasDictValueSafe custom_root_data #items then
			(
				custom_items = custom_root_data[#items]
				child_key = this.findSavedItemKeyByTitle custom_items menu_title

				if child_key != undefined then
				(
					child_data = custom_items[child_key]

					found_menu_data = Dictionary #name
					found_menu_data[#version] = this.version
					found_menu_data[#id] = child_key
					found_menu_data[#title] = child_data[#title]
					found_menu_data[#type] = #menu
					found_menu_data[#items] = child_data[#items]
					found_menu_data[#quad_context_id] = ""
					found_menu_data[#quad_modifier] = undefined
					found_menu_data[#quad_position] = undefined
					found_menu_data[#quad_menu_id] = ""
					found_menu_data[#qmnx_clear_directory] = this.qmnx_clear_directory
					found_menu_data[#clear_defaul_menu] = false
					found_menu_data[#quad_menus] = #()
				)
			)
		)

		found_menu_data -- return
	),


	function mergeSavedItemData old_item_data new_item_data =
	(
		merged_item_data = new_item_data

		if this.isSubMenuData old_item_data and this.isSubMenuData new_item_data then
		(
			merged_item_data = old_item_data
			merged_item_data[#title] = new_item_data[#title]
			merged_item_data[#items] = this.mergeSavedItems old_item_data[#items] new_item_data[#items]
		)

		merged_item_data -- return
	),


	function mergeSavedItems old_items new_items =
	(
		merged_items = Dictionary #string

		if this.isDictionaryValue old_items then
		(
			old_item_keys = GetDictKeys old_items

			for old_item_key in old_item_keys do
			(
				merged_items[old_item_key] = old_items[old_item_key]
			)
		)

		if this.isDictionaryValue new_items then
		(
			new_item_keys = GetDictKeys new_items

			for new_item_key in new_item_keys do
			(
				new_item_data = new_items[new_item_key]
				new_item_title = this.getSavedItemTitle new_item_data
				old_item_key = this.findSavedItemKeyByTitle merged_items new_item_title

				if old_item_key != undefined and new_item_title != "" then
				(
					old_item_data = merged_items[old_item_key]
					merged_items[old_item_key] = this.mergeSavedItemData old_item_data new_item_data
				)
				else
				(
					merged_items[new_item_key] = new_item_data
				)
			)
		)

		merged_items -- return
	),


	function getSavedQuadPositionText quad_data =
	(
		position_text = ""

		if this.isDictionaryValue quad_data then
		(
			if this.hasDictValueSafe quad_data #quad_position then
			(
				position_text = quad_data[#quad_position] as string
			)
		)

		position_text -- return
	),


	function findSavedQuadDataIndexByPosition quad_menus position_text =
	(
		found_index = 0

		if classOf quad_menus == Array then
		(
			for quad_index = 1 to quad_menus.count while found_index == 0 do
			(
				if this.getSavedQuadPositionText quad_menus[quad_index] == position_text then
				(
					found_index = quad_index
				)
			)
		)

		found_index -- return
	),


	function mergeSavedQuadData old_quad_data new_quad_data =
	(
		merged_quad_data = old_quad_data

		if this.hasDictValueSafe new_quad_data #title then
		(
			merged_quad_data[#title] = new_quad_data[#title]
		)

		if this.hasDictValueSafe new_quad_data #quad_position then
		(
			merged_quad_data[#quad_position] = new_quad_data[#quad_position]
		)

		if not this.hasDictValueSafe merged_quad_data #quad_menu_id then
		(
			if this.hasDictValueSafe new_quad_data #quad_menu_id then
			(
				merged_quad_data[#quad_menu_id] = new_quad_data[#quad_menu_id]
			)
		)

		old_items = Dictionary #string
		new_items = Dictionary #string

		if this.hasDictValueSafe old_quad_data #items then
		(
			old_items = old_quad_data[#items]
		)

		if this.hasDictValueSafe new_quad_data #items then
		(
			new_items = new_quad_data[#items]
		)

		merged_quad_data[#items] = this.mergeSavedItems old_items new_items

		merged_quad_data -- return
	),


	function mergeSavedQuadMenus old_quad_menus new_quad_menus =
	(
		merged_quad_menus = #()

		if classOf old_quad_menus == Array then
		(
			for old_quad_data in old_quad_menus do
			(
				append merged_quad_menus old_quad_data
			)
		)

		if classOf new_quad_menus == Array then
		(
			for new_quad_data in new_quad_menus do
			(
				new_position_text = this.getSavedQuadPositionText new_quad_data
				old_quad_index = this.findSavedQuadDataIndexByPosition merged_quad_menus new_position_text

				if old_quad_index > 0 and new_position_text != "" then
				(
					merged_quad_menus[old_quad_index] = this.mergeSavedQuadData merged_quad_menus[old_quad_index] new_quad_data
				)
				else
				(
					append merged_quad_menus new_quad_data
				)
			)
		)

		merged_quad_menus -- return
	),


	function mergeSavedMenuData old_menu_data new_menu_data =
	(
		merged_menu_data = old_menu_data

		merged_menu_data[#version] = this.version

		if this.hasDictValueSafe new_menu_data #title then
		(
			merged_menu_data[#title] = new_menu_data[#title]
		)

		if this.hasDictValueSafe new_menu_data #type then
		(
			merged_menu_data[#type] = new_menu_data[#type]
		)

		if this.hasDictValueSafe new_menu_data #quad_context_id then
		(
			merged_menu_data[#quad_context_id] = new_menu_data[#quad_context_id]
		)

		if this.hasDictValueSafe new_menu_data #quad_modifier then
		(
			merged_menu_data[#quad_modifier] = new_menu_data[#quad_modifier]
		)

		if this.hasDictValueSafe new_menu_data #quad_position then
		(
			merged_menu_data[#quad_position] = new_menu_data[#quad_position]
		)

		if this.hasDictValueSafe new_menu_data #qmnx_clear_directory then
		(
			if new_menu_data[#qmnx_clear_directory] != "" then
			(
				merged_menu_data[#qmnx_clear_directory] = new_menu_data[#qmnx_clear_directory]
			)
		)

		if this.hasDictValueSafe new_menu_data #clear_defaul_menu then
		(
			if new_menu_data[#clear_defaul_menu] == true then
			(
				merged_menu_data[#clear_defaul_menu] = true
			)
		)

		old_items = Dictionary #string
		new_items = Dictionary #string

		if this.hasDictValueSafe old_menu_data #items then
		(
			old_items = old_menu_data[#items]
		)

		if this.hasDictValueSafe new_menu_data #items then
		(
			new_items = new_menu_data[#items]
		)

		merged_menu_data[#items] = this.mergeSavedItems old_items new_items

		old_quad_menus = #()
		new_quad_menus = #()

		if this.hasDictValueSafe old_menu_data #quad_menus then
		(
			old_quad_menus = old_menu_data[#quad_menus]
		)

		if this.hasDictValueSafe new_menu_data #quad_menus then
		(
			new_quad_menus = new_menu_data[#quad_menus]
		)

		merged_menu_data[#quad_menus] = this.mergeSavedQuadMenus old_quad_menus new_quad_menus

		merged_menu_data -- return
	),


	function mergeSavedMenusData old_menus_data new_menus_data =
	(
		merged_menus_data = #()

		for old_menu_data in old_menus_data do
		(
			old_signature = this.getMenuDataSignature old_menu_data

			if old_signature != "" then
			(
				append merged_menus_data old_menu_data
			)
		)

		for new_menu_data in new_menus_data do
		(
			new_signature = this.getMenuDataSignature new_menu_data

			if new_signature != "" then
			(
				merge_index = 0

				for menu_index = 1 to merged_menus_data.count while merge_index == 0 do
				(
					if this.getMenuDataSignature merged_menus_data[menu_index] == new_signature then
					(
						merge_index = menu_index
					)
				)

				if merge_index > 0 then
				(
					merged_menus_data[merge_index] = this.mergeSavedMenuData merged_menus_data[merge_index] new_menu_data
				)
				else
				(
					append merged_menus_data new_menu_data
				)
			)
		)

		merged_menus_data = this.groupMenusUnderCustomMenuRoot merged_menus_data

		merged_menus_data -- return
	),

	function deleteMenusFromJsonBySignatures signatures =
	(
		old_menus_data = this.loadSavedMenusDataFromJson()
		new_menus_data = #()

		for menu_data in old_menus_data do
		(
			menu_signature = this.getMenuDataSignature menu_data

			if not this.isStringInArray signatures menu_signature then
			(
				append new_menus_data menu_data
			)
		)

		this.saved_menus_data = this.groupMenusUnderCustomMenuRoot new_menus_data
		this.writeSavedMenusDataToJson this.saved_menus_data

		this.saved_menus_data -- return
	),


	function collectDefaultQuadClearPositionsFromMenuData menu_data =
	(
		clear_positions = #()

		if this.hasDictValueSafe menu_data #quad_menus then
		(
			quad_menus = menu_data[#quad_menus]

			if classOf quad_menus == Array and quad_menus.count > 0 then
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
				if this.hasDictValueSafe menu_data #quad_position then
				(
					append clear_positions menu_data[#quad_position]
				)
			)
		)
		else
		(
			if this.hasDictValueSafe menu_data #quad_position then
			(
				append clear_positions menu_data[#quad_position]
			)
		)

		clear_positions -- return
	),


	function clearDefaultQuadPositionsForAllData =
	(
		clear_positions = #()
		clear_directory = this.qmnx_clear_directory

		for menu_data in this.saved_menus_data do
		(
			if (this.isDefaultQuadInjectionData menu_data) and (this.getSavedClearDefaulMenu menu_data) then
			(
				if clear_directory == "" then
				(
					clear_directory = this.getSavedQmnxClearDirectory menu_data
				)

				menu_clear_positions = this.collectDefaultQuadClearPositionsFromMenuData menu_data

				for position_value in menu_clear_positions do
				(
					append clear_positions position_value
				)
			)
		)

		if clear_positions.count > 0 then
		(
			qmnx_clear = QuadDefaultQmnxClear_v qmnx_clear_directory:clear_directory
			qmnx_clear.clearPositions clear_positions
		)

		clear_positions -- return
	),



	function getMenuDefinitionSignature menu_definition =
	(
		signature = ""

		try
		(
			definition_type = this.normalizeMenuType menu_definition.type
			definition_title = menu_definition.title

			if definition_title != undefined and definition_title != "" then
			(
				signature = (definition_type as string) + "|" + definition_title
			)
		)
		catch
		(
			signature = ""
		)

		signature -- return
	),


	function findMenuDefinitionIndexBySignature menu_definition_array signature =
	(
		found_index = 0

		if signature != "" then
		(
			for definition_index = 1 to menu_definition_array.count while found_index == 0 do
			(
				menu_definition = menu_definition_array[definition_index]
				menu_definition_signature = this.getMenuDefinitionSignature menu_definition

				if menu_definition_signature == signature then
				(
					found_index = definition_index
				)
			)
		)

		found_index -- return
	),


	function mergeDefinitionDictionaries old_dictionary new_dictionary =
	(
		if this.isDictionaryValue old_dictionary and this.isDictionaryValue new_dictionary then
		(
			new_keys = GetDictKeys new_dictionary

			for new_key in new_keys do
			(
				new_value = new_dictionary[new_key]

				if HasDictValue old_dictionary new_key then
				(
					old_value = old_dictionary[new_key]

					if this.isDictionaryValue old_value and this.isDictionaryValue new_value then
					(
						old_dictionary[new_key] = this.mergeDefinitionDictionaries old_value new_value
					)
					else
					(
						old_dictionary[new_key] = new_value
					)
				)
				else
				(
					old_dictionary[new_key] = new_value
				)
			)
		)

		old_dictionary -- return
	),


	function mergeMenuDefinitionInto old_menu_definition new_menu_definition =
	(
		try
		(
			old_data = this.getDefinitionData old_menu_definition
			new_data = this.getDefinitionData new_menu_definition

			if this.isDictionaryValue old_data and this.isDictionaryValue new_data then
			(
				old_menu_definition.data = this.mergeDefinitionDictionaries old_data new_data
			)
			else
			(
				old_menu_definition = new_menu_definition
			)
		)
		catch
		(
			old_menu_definition = new_menu_definition
		)

		old_menu_definition -- return
	),


	function addMenuDefinitionToArrayUnique menu_definition_array menu_definition =
	(
		definition_signature = this.getMenuDefinitionSignature menu_definition

		if definition_signature == "" then
		(
			append menu_definition_array menu_definition
		)
		else
		(
			existing_index = this.findMenuDefinitionIndexBySignature menu_definition_array definition_signature

			if existing_index > 0 then
			(
				menu_definition_array[existing_index] = this.mergeMenuDefinitionInto menu_definition_array[existing_index] menu_definition
			)
			else
			(
				append menu_definition_array menu_definition
			)
		)

		menu_definition_array -- return
	),


	/** Add menu data to build queue without creating duplicate references.
		If menu_data already exists in menus_data, it is already owned by this manager,
		so it is not queued again. This prevents same growing MenuDefinition_v from
		being built dozens of times and exploding memory.
	*/
	function waitForBuild menu_data =
	(
		if menu_data != undefined then
		(
			if this.isArrayValue menu_data then
			(
				for menu_data_item in menu_data do
				(
					this.waitForBuild menu_data_item
				)
			)
			else
			(
				definition_signature = this.getMenuDefinitionSignature menu_data
				managed_index = this.findMenuDefinitionIndexBySignature this.menus_data definition_signature

				if managed_index > 0 then
				(
					this.menus_data[managed_index] = this.mergeMenuDefinitionInto this.menus_data[managed_index] menu_data
				)
				else
				(
					this.wait_for_build = this.addMenuDefinitionToArrayUnique this.wait_for_build menu_data
				)
			)
		)

		this -- return
	),



	function clearWaitForBuild =
	(
		this.wait_for_build = #()

		this -- return
	),



	function applyWaitForBuildToMenusData =
	(
		if this.wait_for_build.count > 0 then
		(
			for menu_data_item in this.wait_for_build do
			(
				this.menus_data = this.addMenuDefinitionToArrayUnique this.menus_data menu_data_item
			)

			this.wait_for_build = #()
			this.saved_menus_data = #()
		)

		this.menus_data -- return
	),

	function buildMenus =
	(
		if this.saved_menus_data.count == 0 then
		(
			this.buildSavedMenusData()
		)

		this.saved_menus_data -- return
	),


	function saveJsonData =
	(
		json_io = MenuJsonIO_v()

		if this.saved_menus_data.count == 0 then
		(
			this.buildSavedMenusData()
		)

		if this.merge_existing_data then
		(
			old_menus_data = this.loadSavedMenusDataFromJson()
			this.saved_menus_data = this.mergeSavedMenusData old_menus_data this.saved_menus_data
		)

		this.saved_menus_data = this.groupMenusUnderCustomMenuRoot this.saved_menus_data

		saved_path = this.writeSavedMenusDataToJson this.saved_menus_data

		if this.split_json_enabled then
		(
			format "Split menu JSON data saved to:\n%\n" saved_path
		)
		else
		(
			format "Menu JSON data saved to:\n%\n" saved_path
		)

		saved_path -- return
	),


	function createStartupScriptText =
	(
		startup_text = ""

		startup_text += "/*\n"
		startup_text += "    Auto generated menu startup loader.\n"
		startup_text += "    Data file: " + this.data_file_path + "\n"
		startup_text += "*/\n\n"

		startup_text += "global MenuBuildManager\n"
		startup_text += "global MenuRebuilder_qmnx_clear_guard = false\n\n"

		if this.rebuilder_file_path != "" then
		(
			startup_text += "try\n"
			startup_text += "(\n"
			startup_text += "	fileIn @\"" + this.rebuilder_file_path + "\"\n"
			startup_text += ")\n"
			startup_text += "catch\n"
			startup_text += "(\n"
			startup_text += "	startup_exception = getCurrentException()\n"
			startup_text += "	format \"Failed to fileIn MenuRebuilder file.\\n%\\n\" startup_exception\n"
			startup_text += "	throw\n"
			startup_text += ")\n\n"
		)

		startup_text += "try\n"
		startup_text += "(\n"
		startup_text += "	MenuBuildManager = MenuBuildManager_v data_file_path:@\"" + this.data_file_path + "\" merge_existing_data:false qmnx_clear_directory:@\"" + this.qmnx_clear_directory + "\"\n"
		startup_text += "	saved_menus_data = MenuBuildManager.loadSavedMenusDataFromJson()\n"
		startup_text += "	MenuBuildManager.saved_menus_data = saved_menus_data\n"
		startup_text += "	format \"MenuBuildManager startup loaded % saved menus.\\n\" saved_menus_data.count\n"
		startup_text += "	MenuBuildManager.registerCallback()\n"
		startup_text += "	format \"MenuBuildManager callbacks registered from JSON data.\\n\"\n"
		startup_text += ")\n"
		startup_text += "catch\n"
		startup_text += "(\n"
		startup_text += "	startup_exception = getCurrentException()\n"
		startup_text += "	format \"Menu rebuild from JSON failed.\\n%\\n\" startup_exception\n"
		startup_text += "	throw\n"
		startup_text += ")\n"

		startup_text -- return
	),


	function saveStartupScript =
	(
		startup_text = this.createStartupScriptText()

		startup_file = createFile this.startup_file_path
		format "%" startup_text to:startup_file
		close startup_file

		format "Startup loader saved to:\n%\n" this.startup_file_path

		this.startup_file_path -- return
	),


	function loadAllMenus =
	(
		menu_manager = callbacks.notificationParam()

		if menu_manager == undefined then
		(
			format "MenuBuildManager_v.loadAllMenus failed. menu_manager is undefined.\n"
		)
		else
		(
			if this.saved_menus_data.count == 0 then
			(
				this.saved_menus_data = this.loadSavedMenusDataFromJson()
			)

			this.saved_menus_data = this.groupMenusUnderCustomMenuRoot this.saved_menus_data
			format "MenuBuildManager_v.loadAllMenus: % saved menus loaded.\n" this.saved_menus_data.count

			for menu_data in this.saved_menus_data do
			(
				if this.isMenuCallbackData menu_data then
				(
					menu_rebuilder = MenuRebuilder_v menu_data:menu_data
					menu_rebuilder.rebuildAsMainMenu menu_manager
				)
			)
		)

		ok -- return
	),


	function loadAllQuadMenus =
	(
		global MenuRebuilder_qmnx_clear_guard

		if MenuRebuilder_qmnx_clear_guard then
		(
			format "MenuBuildManager_v.loadAllQuadMenus skipped. QMNX clear guard is active.\n"
			ok -- return
		)
		else
		(
			quad_menu_manager = callbacks.notificationParam()

			if quad_menu_manager == undefined then
			(
				format "MenuBuildManager_v.loadAllQuadMenus failed. quad_menu_manager is undefined.\n"
			)
			else
			(
				if this.saved_menus_data.count == 0 then
				(
					this.saved_menus_data = this.loadSavedMenusDataFromJson()
				)

				this.saved_menus_data = this.groupMenusUnderCustomMenuRoot this.saved_menus_data
				format "MenuBuildManager_v.loadAllQuadMenus: % saved menus loaded.\n" this.saved_menus_data.count

				this.clearDefaultQuadPositionsForAllData()

				for menu_data in this.saved_menus_data do
				(
					if this.isQuadCallbackData menu_data then
					(
						menu_rebuilder = MenuRebuilder_v \
							menu_data:menu_data \
							skip_default_qmnx_clear:true

						menu_rebuilder.rebuildAsQuadMenu quad_menu_manager
					)
				)
			)

			ok -- return
		)
	),

	function hasMenuCallbackData =
	(
		was_found = false

		for menu_data in this.saved_menus_data while not was_found do
		(
			was_found = this.isMenuCallbackData menu_data
		)

		was_found -- return
	),


	function hasQuadCallbackData =
	(
		was_found = false

		for menu_data in this.saved_menus_data while not was_found do
		(
			was_found = this.isQuadCallbackData menu_data
		)

		was_found -- return
	),


	function registerCallback =
	(
		global MenuBuildManager

		if this.saved_menus_data.count == 0 then
		(
			this.saved_menus_data = this.loadSavedMenusDataFromJson()
		)

		if this.saved_menus_data.count == 0 then
		(
			this.buildSavedMenusData()
		)

		this.saved_menus_data = this.groupMenusUnderCustomMenuRoot this.saved_menus_data
		format "MenuBuildManager_v.registerCallback: % saved menus loaded.\n" this.saved_menus_data.count

		MenuBuildManager = this

		callbacks.removeScripts id:this.callback_id
		callbacks.removeScripts id:this.quad_callback_id

		if this.hasMenuCallbackData() then
		(
			callbacks.addScript #cuiRegisterMenus "MenuBuildManager.loadAllMenus()" id:this.callback_id
		)

		if this.hasQuadCallbackData() then
		(
			callbacks.addScript #cuiRegisterQuadMenus "MenuBuildManager.loadAllQuadMenus()" id:this.quad_callback_id
		)

		ok -- return
	),


	function unregisterCallback =
	(
		callbacks.removeScripts id:this.callback_id
		callbacks.removeScripts id:this.quad_callback_id

		ok -- return
	),


	function run =
	(
		format "\n"; print "MenuBuildManager_v.build()"
		timer_run = timeStamp()

		this.applyWaitForBuildToMenusData()
		this.buildMenus()
		this.saveJsonData()

		if this.auto_register_callback then
		(
			this.registerCallback()
		)

		this.saveStartupScript()

		format "run: % ms\n" (( timeStamp()) - timer_run)
		
		this.saved_menus_data -- return
	),
	
	/** Build queued/current menu definitions and update JSON once.
	*/
	function build =
	(
		format "\n"; print "MenuBuildManager_v.build()"
		timer_build = timeStamp()
		this.applyWaitForBuildToMenusData()
		this.saved_menus_data = #()

		this.buildMenus()
		this.saveJsonData()
		this.saveStartupScript()

		format "build: % ms\n" (( timeStamp()) - timer_build)
		this.saved_menus_data -- return
	),


	/** Backward compatible helper for one menu definition.
	*/
	function buildMenu menu_data =
	(
		format "\n"; print "MenuBuildManager_v.buildMenu()"

		this.waitForBuild menu_data
		this.build()

		this.saved_menus_data -- return
	),


	on create do
	(
		format "\n"; print "MenuBuildManager_v.onCreate()"

		startup_directory = this.getDefaultStartupDirectory()

		if this.data_file_path == "" then
		(
			this.data_file_path = startup_directory + "\\" + this.data_file_name
		)

		if this.startup_file_path == "" then
		(
			this.startup_file_path = startup_directory + "\\" + this.startup_file_name
		)

		if this.rebuilder_file_path == "" then
		(
			this.rebuilder_file_path = this.getCurrentSourceFilePath()
		)
	)
)


