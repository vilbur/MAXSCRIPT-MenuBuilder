fileIn( getFilenamePath(getSourceFileName()) + "/../include-menus.ms" )

/*
	MenuBuildManager_v 0.45
	Ordered item schema + split JSON development storage + native .msdata production cache.

	Compile modes:
	#PRODUCTION = native .msdata only. Fast startup/runtime cache.
	#JSON       = split JSON only. Development/debug mode.
*/
struct MenuBuildManager_v
(
	version = 0.45,
	menus_data = #(),
	wait_for_build = #(),
	saved_menus_data = #(),
	data_file_name = "MenuRebuilder_data.json",
	data_folder_name = "MenuRebuilder_data",
	menus_folder_name = "menus",
	quads_folder_name = "quads",
	split_json_enabled = true,
	split_json_cache_enabled = true,
	split_json_cache_valid = false,
	split_json_cache_data = #(),
	split_json_cache_load_ms = 0,
	split_data_root_directory = "",
	compile_mode = #PRODUCTION,
	data_storage_mode = undefined,
	native_data_file_name = "MenuRebuilder_data.msdata",
	native_data_file_path = "",
	native_data_io_file_name = "MenuNativeDataIO_v_0.03.ms",
	native_data_io_file_path = "",
	custom_menu_root_title = "_Custom-Menus",
	custom_menu_root_id = "4a93a53d-8cf7-4d16-b217-8fe6c2b9d6f1",
	main_menu_bar_title = "Main Menu Bar",
	startup_file_name = "MenuRebuilder_startup.ms",
	data_file_path = "",
	startup_file_path = "",
	rebuilder_file_path = "",
	qmnx_clear_directory = "",
	clear_default_menu = false,
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
		if value != undefined then if classOf value == Dictionary then was_dictionary = true
		was_dictionary -- return
	),


	function isArrayValue value =
	(
		was_array = false
		if value != undefined then if classOf value == Array then was_array = true
		was_array -- return
	),


	function hasDictValueSafe dictionary_value dictionary_key =
	(
		was_found = false
		if this.isDictionaryValue dictionary_value then
		(
			try (was_found = HasDictValue dictionary_value dictionary_key) catch (was_found = false)
		)
		was_found -- return
	),


	function cloneDictionaryValue source_dictionary =
	(
		source_keys = GetDictKeys source_dictionary
		dictionary_type = #string
		if source_keys.count > 0 then if classOf source_keys[1] == Name then dictionary_type = #name
		cloned_dictionary = Dictionary dictionary_type
		for source_key in source_keys do cloned_dictionary[source_key] = this.cloneValue source_dictionary[source_key]
		cloned_dictionary -- return
	),


	function cloneArrayValue source_array =
	(
		cloned_array = #()
		for source_value in source_array do append cloned_array (this.cloneValue source_value)
		cloned_array -- return
	),


	function cloneValue source_value =
	(
		cloned_value = source_value
		if this.isDictionaryValue source_value then cloned_value = this.cloneDictionaryValue source_value
		else if this.isArrayValue source_value then cloned_value = this.cloneArrayValue source_value
		cloned_value -- return
	),


	function getDefaultStartupDirectory =
	(
		startup_directory = ""
		try (startup_directory = getDir #userStartupScripts) catch (startup_directory = getDir #userScripts + "\\startup")
		try (makeDir startup_directory all:true) catch (ok)
		startup_directory -- return
	),


	function getCurrentSourceFilePath =
	(
		source_file_path = ""
		try (source_file_path = getSourceFileName()) catch (source_file_path = "")
		source_file_path -- return
	),


	/*
	Normalize compile mode.
	#PRODUCTION uses MenuNativeDataIO_v. #JSON uses MenuJsonIO_v.
	*/
	function normalizeCompileMode mode_value =
	(
		normalized_mode = #PRODUCTION
		mode_text = mode_value as string

		if mode_text == "#PRODUCTION" then normalized_mode = #PRODUCTION
		if mode_text == "PRODUCTION" then normalized_mode = #PRODUCTION
		if mode_text == "#production" then normalized_mode = #PRODUCTION
		if mode_text == "production" then normalized_mode = #PRODUCTION

		if mode_text == "#JSON" then normalized_mode = #JSON
		if mode_text == "JSON" then normalized_mode = #JSON
		if mode_text == "#json" then normalized_mode = #JSON
		if mode_text == "json" then normalized_mode = #JSON

		normalized_mode -- return
	),


	/*
	Resolve compile mode.
	Old data_storage_mode is accepted only when compile_mode is undefined.
	*/
	function getCompileMode =
	(
		resolved_mode = this.compile_mode

		if resolved_mode == undefined then
		(
			if this.data_storage_mode != undefined then
			(
				data_storage_text = this.data_storage_mode as string

				if data_storage_text == "#json" or data_storage_text == "json" then
				(
					resolved_mode = #JSON
				)
				else
				(
					resolved_mode = #PRODUCTION
				)
			)
			else
			(
				resolved_mode = #PRODUCTION
			)
		)

		this.normalizeCompileMode resolved_mode -- return
	),

	/*
	Get native data cache path.
	Default lives next to JSON data file.
	*/
	function getNativeDataFilePath =
	(
		file_path = this.native_data_file_path
		if file_path == "" then file_path = (getFilenamePath this.data_file_path) + this.native_data_file_name
		file_path -- return
	),


	/*
	Get MenuNativeDataIO source path.
	Default lives next to manager file.
	*/
	function getNativeDataIOFilePath =
	(
		file_path = this.native_data_io_file_path
		if file_path == "" then file_path = (getFilenamePath this.rebuilder_file_path) + this.native_data_io_file_name
		file_path -- return
	),


	/*
	Get MenuNativeDataIO_v instance.
	Loads helper file if struct is not already defined.
	*/
	function getNativeDataIO =
	(
		native_io = undefined
		try
		(
			native_io = MenuNativeDataIO_v()
		)
		catch
		(
			try
			(
				fileIn (this.getNativeDataIOFilePath())
				native_io = MenuNativeDataIO_v()
			)
			catch
			(
				format "MenuNativeDataIO_v is not defined. Native cache skipped.\n"
				native_io = undefined
			)
		)
		native_io -- return
	),


	/*
	Load saved menu data from native cache.
	Returns empty array when cache is missing or invalid.
	*/
	function loadSavedMenusDataFromNativeFile =
	(
		menus_data_array = #()
		native_io = this.getNativeDataIO()
		if native_io != undefined then
		(
			native_file_path = this.getNativeDataFilePath()
			menus_data_array = native_io.loadDataFromNativeFile native_file_path
			if menus_data_array.count > 0 then format "Native menu cache loaded: % menus from %\n" menus_data_array.count native_file_path
		)
		menus_data_array -- return
	),


	/*
	Save saved menu data to native cache.
	This is the production-fast storage path.
	*/
	function saveSavedMenusDataToNativeFile menus_data_array =
	(
		saved_path = ""
		native_io = this.getNativeDataIO()
		if native_io != undefined then
		(
			saved_path = this.getNativeDataFilePath()
			native_io.saveDataToNativeFile menus_data_array saved_path
			format "Native menu cache saved: % menus to %\n" menus_data_array.count saved_path
		)
		saved_path -- return
	),


	function normalizeMenuType type_value =
	(
		normalized_type = #menu
		type_text = type_value as string
		if type_text == "#quad" then normalized_type = #quad
		if type_text == "quad" then normalized_type = #quad
		if type_text == "#both" then normalized_type = #both
		if type_text == "both" then normalized_type = #both
		normalized_type -- return
	),


	function normalizeQuadModifier modifier_value =
	(
		normalized_modifier = modifier_value
		try
		(
			menu_rebuilder = MenuRebuilder_v()
			normalized_modifier = menu_rebuilder.normalizeQuadModifier modifier_value
		)
		catch
		(
			modifier_text = modifier_value as string
			case modifier_text of
			(
				"#nonePressed": normalized_modifier = #nonePressed
				"nonePressed": normalized_modifier = #nonePressed
				"#shiftAndControlPressed": normalized_modifier = #shiftAndControlPressed
				"shiftAndControlPressed": normalized_modifier = #shiftAndControlPressed
				default: normalized_modifier = modifier_value
			)
		)
		normalized_modifier -- return
	),


	function getDefinitionData menu_definition =
	(
		definition_data = menu_definition.data
		if menu_definition._data != undefined then definition_data = menu_definition._data
		definition_data -- return
	),


	function getDefinitionId menu_definition =
	(
		definition_id = ""
		try (definition_id = menu_definition.id) catch (definition_id = "")
		if definition_id == undefined then definition_id = ""
		definition_id -- return
	),


	function getDefinitionQuadMenuId menu_definition =
	(
		definition_quad_menu_id = ""
		try (definition_quad_menu_id = menu_definition.quad_menu_id) catch (definition_quad_menu_id = "")
		if definition_quad_menu_id == undefined then definition_quad_menu_id = ""
		definition_quad_menu_id -- return
	),


	function createSavedMacroItemData item_title macro_category macro_name id:undefined =
	(
		item_data = Dictionary #name
		item_id = id
		if item_id == undefined then item_id = this.createGuidString()
		item_data[#id] = item_id
		item_data[#title] = item_title
		item_data[#category] = macro_category
		item_data[#macro] = macro_name
		item_data -- return
	),


	function createSavedSubMenuData submenu_title submenu_items id:undefined =
	(
		submenu_data = Dictionary #name
		submenu_id = id
		if submenu_id == undefined then submenu_id = this.createGuidString()
		submenu_data[#id] = submenu_id
		submenu_data[#title] = submenu_title
		submenu_data[#items] = submenu_items
		submenu_data -- return
	),


	function isSubMenuData item_data =
	(
		was_found = false
		if this.isDictionaryValue item_data then was_found = this.hasDictValueSafe item_data #items
		was_found -- return
	),


	function isMacroItemData item_data =
	(
		was_found = false
		if this.isDictionaryValue item_data then
		(
			was_found = this.hasDictValueSafe item_data #category
			if was_found then was_found = this.hasDictValueSafe item_data #macro
		)
		was_found -- return
	),


	function isSavedItemData item_data =
	(
		was_found = false
		if this.isDictionaryValue item_data then
		(
			was_found = this.hasDictValueSafe item_data #title
			if was_found then was_found = (this.isSubMenuData item_data) or (this.isMacroItemData item_data)
		)
		was_found -- return
	),


	function normalizeMenuItems items_value =
	(
		normalized_items = #()
		if this.isArrayValue items_value then
		(
			for item_value in items_value do
			(
				if this.isSavedItemData item_value then
				(
					if not (this.hasDictValueSafe item_value #id) then item_value[#id] = this.createGuidString()
					if this.hasDictValueSafe item_value #items then item_value[#items] = this.normalizeMenuItems item_value[#items]
					append normalized_items item_value
				)
			)
		)
		else if this.isDictionaryValue items_value then
		(
			item_keys = GetDictKeys items_value
			for item_key in item_keys do
			(
				item_value = items_value[item_key]
				item_id = item_key as string
				if this.isSavedItemData item_value then
				(
					item_value[#id] = item_id
					if this.hasDictValueSafe item_value #items then item_value[#items] = this.normalizeMenuItems item_value[#items]
					append normalized_items item_value
				)
				else if this.isDictionaryValue item_value then append normalized_items (this.createSavedSubMenuData item_id (this.normalizeMenuItems item_value) id:item_id)
				else if classOf item_value == Array then if item_value.count >= 2 then append normalized_items (this.createSavedMacroItemData item_id item_value[1] item_value[2] id:item_id)
			)
		)
		normalized_items -- return
	),


	function getMenuDataValue menu_data key_name default_value =
	(
		result_value = default_value
		if this.hasDictValueSafe menu_data key_name then result_value = menu_data[key_name]
		result_value -- return
	),


	function getSavedMenuType menu_data =
	(
		saved_type = #menu
		if this.isDictionaryValue menu_data then if this.hasDictValueSafe menu_data #type then saved_type = this.normalizeMenuType menu_data[#type]
		saved_type -- return
	),


	function getSavedMenuTitle menu_data =
	(
		menu_title = ""
		if this.isDictionaryValue menu_data then if this.hasDictValueSafe menu_data #title then menu_title = menu_data[#title]
		menu_title -- return
	),


	function getSavedItemTitle item_data =
	(
		item_title = ""
		if this.isDictionaryValue item_data then if this.hasDictValueSafe item_data #title then item_title = item_data[#title]
		item_title -- return
	),


	function getSavedQuadModifier menu_data =
	(
		quad_modifier = undefined
		if this.isDictionaryValue menu_data then if this.hasDictValueSafe menu_data #quad_modifier then quad_modifier = this.normalizeQuadModifier menu_data[#quad_modifier]
		quad_modifier -- return
	),


	function getSavedQmnxClearDirectory menu_data =
	(
		clear_directory = ""
		if this.isDictionaryValue menu_data then if this.hasDictValueSafe menu_data #qmnx_clear_directory then clear_directory = menu_data[#qmnx_clear_directory]
		clear_directory -- return
	),


	function getSavedClearDefaultMenu menu_data =
	(
		clear_flag = false
		if this.isDictionaryValue menu_data then if this.hasDictValueSafe menu_data #clear_default_menu then clear_flag = menu_data[#clear_default_menu]
		clear_flag -- return
	),


	function isValidSavedMenuData menu_data =
	(
		(this.getSavedMenuTitle menu_data != "") -- return
	),


	function isMenuCallbackData menu_data =
	(
		saved_type = this.getSavedMenuType menu_data
		if not (this.isValidSavedMenuData menu_data) then false else (saved_type == #menu or saved_type == #both) -- return
	),


	function isQuadCallbackData menu_data =
	(
		saved_type = this.getSavedMenuType menu_data
		if not (this.isValidSavedMenuData menu_data) then false else (saved_type == #quad or saved_type == #both) -- return
	),


	function isDefaultQuadInjectionData menu_data =
	(
		was_found = false
		if this.isQuadCallbackData menu_data then if this.getSavedQuadModifier menu_data == #nonePressed then was_found = true
		was_found -- return
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
			clear_flag = this.clear_default_menu
			try (if menu_definition.clear_default_menu then clear_flag = true) catch (clear_flag = this.clear_default_menu)
			definition_qmnx_clear_directory = this.qmnx_clear_directory
			try (if menu_definition.qmnx_clear_directory != undefined then if menu_definition.qmnx_clear_directory != "" then definition_qmnx_clear_directory = menu_definition.qmnx_clear_directory) catch (ok)

			root_data = Dictionary #name
			root_data[#version] = this.version
			definition_id = this.getDefinitionId menu_definition
			root_data[#id] = if definition_id != "" then definition_id else this.createGuidString()
			root_data[#title] = menu_definition.title
			root_data[#type] = definition_type
			root_data[#items] = #()
			root_data[#quad_context_id] = menu_definition.quad_context_id
			root_data[#quad_modifier] = this.normalizeQuadModifier menu_definition.quad_modifier
			root_data[#quad_position] = if definition_type == #menu then undefined else menu_definition.quad_position
			definition_quad_menu_id = this.getDefinitionQuadMenuId menu_definition
			root_data[#quad_menu_id] = if definition_quad_menu_id != "" then definition_quad_menu_id else this.createGuidString()
			root_data[#qmnx_clear_directory] = definition_qmnx_clear_directory
			root_data[#clear_default_menu] = clear_flag
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
		definition_quad_menu_id = this.getDefinitionQuadMenuId quad_definition
		quad_data[#quad_menu_id] = if definition_quad_menu_id != "" then definition_quad_menu_id else this.createGuidString()
		quad_data[#items] = this.normalizeMenuItems quad_source_data
		quad_data -- return
	),


	function isMenuDefinitionLike value =
	(
		was_definition = false
		try (if value.title != undefined then if value.type != undefined then was_definition = true) catch (was_definition = false)
		was_definition -- return
	),


	function buildSavedQuadRootDataFromDefinition menu_definition =
	(
		root_data = this.createSavedRootData menu_definition #quad
		if root_data != undefined then
		(
			quad_definition_array = this.getDefinitionData menu_definition
			root_data[#items] = #()
			root_data[#quad_menus] = #()
			if this.isArrayValue quad_definition_array then
			(
				if quad_definition_array.count > 0 and this.isMenuDefinitionLike quad_definition_array[1] then
				(
					for quad_definition in quad_definition_array do append root_data[#quad_menus] (this.buildSavedQuadDataFromDefinition quad_definition)
				)
				else root_data[#items] = this.normalizeMenuItems quad_definition_array
			)
		)
		root_data -- return
	),


	function buildSavedSingleRootDataFromDefinition menu_definition definition_type =
	(
		root_data = this.createSavedRootData menu_definition definition_type
		if root_data != undefined then root_data[#items] = this.normalizeMenuItems (this.getDefinitionData menu_definition)
		root_data -- return
	),


	function buildSavedMenuDataFromDefinition menu_definition =
	(
		menu_data = undefined
		definition_type = this.normalizeMenuType menu_definition.type
		definition_data = this.getDefinitionData menu_definition
		if definition_type == #quad and this.isArrayValue definition_data then menu_data = this.buildSavedQuadRootDataFromDefinition menu_definition
		else menu_data = this.buildSavedSingleRootDataFromDefinition menu_definition definition_type
		if menu_data != undefined then menu_data[#version] = this.version
		menu_data -- return
	),


	function buildSavedMenusData =
	(
		this.saved_menus_data = #()
		for menu_definition in this.menus_data do
		(
			menu_data = this.buildSavedMenuDataFromDefinition menu_definition
			if menu_data != undefined then append this.saved_menus_data menu_data
		)
		this.saved_menus_data = this.groupMenusUnderCustomMenuRoot this.saved_menus_data
		this.saved_menus_data -- return
	),


	function getSplitDataRootDirectory =
	(
		root_directory = this.split_data_root_directory
		if root_directory == "" then root_directory = (getFilenamePath this.data_file_path) + this.data_folder_name
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
		try (makeDir (this.getSplitDataRootDirectory()) all:true; makeDir (this.getSplitMenusDirectory()) all:true; makeDir (this.getSplitQuadsDirectory()) all:true) catch (format "MenuBuildManager_v.ensureSplitJsonDirectories failed.\n")
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
		if file_name == "" then file_name = "Untitled_Menu"
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


	function getSplitJsonFilePathByTitle menu_title menu_type:#menu =
	(
		file_name = this.sanitizeJsonFileName menu_title
		file_path = ""
		if this.normalizeMenuType menu_type == #quad then
		(
			file_path = (this.getSplitQuadsDirectory()) + "\\" + file_name + ".json"
		)
		else
		(
			file_path = (this.getSplitMenusDirectory()) + "\\" + file_name + ".json"
		)
		file_path -- return
	),


	function invalidateSplitJsonCache =
	(
		this.split_json_cache_valid = false
		this.split_json_cache_data = #()
		this.split_json_cache_load_ms = 0
		ok -- return
	),


	function setSplitJsonCache menus_data_array load_ms:0 =
	(
		if this.split_json_cache_enabled then
		(
			this.split_json_cache_data = menus_data_array
			this.split_json_cache_valid = true
			this.split_json_cache_load_ms = load_ms
		)
		menus_data_array -- return
	),


	function deleteJsonFilesInDirectory directory_path =
	(
		json_files = getFiles (directory_path + "\\*.json")
		for json_file in json_files do try (deleteFile json_file) catch (format "Could not delete old json file: %\n" json_file)
		json_files.count -- return
	),


	function clearSplitJsonFiles =
	(
		this.ensureSplitJsonDirectories()
		deleted_count = 0
		deleted_count += this.deleteJsonFilesInDirectory (this.getSplitMenusDirectory())
		deleted_count += this.deleteJsonFilesInDirectory (this.getSplitQuadsDirectory())
		this.invalidateSplitJsonCache()
		deleted_count -- return
	),


	function loadMenusDataFromSplitJson force_reload:false =
	(
		if this.split_json_cache_enabled and this.split_json_cache_valid and not force_reload then
		(
			format "SPLIT JSON LOAD: cached % menus in 0 ms. Original load was % ms.\n" this.split_json_cache_data.count this.split_json_cache_load_ms
			this.split_json_cache_data -- return
		)
		else
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
				for menu_data in file_menus_data do append menus_data_array menu_data
			)
			menus_data_array = this.groupMenusUnderCustomMenuRoot menus_data_array
			load_ms = ((timeStamp()) - timer_load_split)
			this.setSplitJsonCache menus_data_array load_ms:load_ms
			format "SPLIT JSON LOAD: % files, % menus in % ms\n" json_files.count menus_data_array.count load_ms
			menus_data_array -- return
		)
	),


	function loadSavedMenusDataFromJsonSource =
	(
		menus_data_array = #()
		if this.split_json_enabled then
		(
			menus_data_array = this.loadMenusDataFromSplitJson()
			if menus_data_array.count == 0 then
			(
				json_io = MenuJsonIO_v()
				menus_data_array = json_io.loadMenusDataFromJsonFile this.data_file_path
				menus_data_array = this.groupMenusUnderCustomMenuRoot menus_data_array
			)
		)
		else
		(
			json_io = MenuJsonIO_v()
			menus_data_array = json_io.loadMenusDataFromJsonFile this.data_file_path
			menus_data_array = this.groupMenusUnderCustomMenuRoot menus_data_array
		)
		menus_data_array -- return
	),


	function writeSavedMenusDataToJsonSource menus_data_array =
	(
		saved_path = this.data_file_path
		if this.split_json_enabled then
		(
			saved_path = this.saveMenusDataToSplitJson menus_data_array
			if doesFileExist this.data_file_path then try (deleteFile this.data_file_path; format "Removed stale single JSON file:\n%\n" this.data_file_path) catch (ok)
		)
		else
		(
			json_io = MenuJsonIO_v()
			json_io.saveMenusDataToJsonFile menus_data_array this.data_file_path
			this.invalidateSplitJsonCache()
		)
		saved_path -- return
	),


	/*
	Load saved menu data by compile mode.
	#PRODUCTION reads native .msdata only. #JSON reads split JSON only.
	*/
	function loadSavedMenusDataFromDisk =
	(
		menus_data_array = #()
		resolved_compile_mode = this.getCompileMode()

		if resolved_compile_mode == #PRODUCTION then
		(
			menus_data_array = this.loadSavedMenusDataFromNativeFile()
		)
		else
		(
			menus_data_array = this.loadSavedMenusDataFromJsonSource()
		)

		menus_data_array -- return
	),


	/*
	Write saved menu data by compile mode.
	#PRODUCTION writes native .msdata only. #JSON writes split JSON only.
	*/
	function writeSavedMenusDataToDisk menus_data_array =
	(
		saved_path = this.data_file_path
		resolved_compile_mode = this.getCompileMode()

		if resolved_compile_mode == #PRODUCTION then
		(
			saved_path = this.saveSavedMenusDataToNativeFile menus_data_array
		)
		else
		(
			saved_path = this.writeSavedMenusDataToJsonSource menus_data_array
		)

		saved_path -- return
	),

	function loadSavedMenusDataFromJson =
	(
		this.loadSavedMenusDataFromDisk() -- return
	),


	function writeSavedMenusDataToJson menus_data_array =
	(
		this.writeSavedMenusDataToDisk menus_data_array -- return
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
			if menu_title != "" then if not (this.isCustomMenuRootTitle menu_title) then if not (this.isMainMenuBarTitle menu_title) then should_nest = true
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
		root_data[#items] = #()
		root_data[#quad_context_id] = ""
		root_data[#quad_modifier] = undefined
		root_data[#quad_position] = undefined
		root_data[#quad_menu_id] = ""
		root_data[#qmnx_clear_directory] = this.qmnx_clear_directory
		root_data[#clear_default_menu] = false
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
		submenu_data[#id] = menu_data[#id]
		submenu_data[#title] = menu_data[#title]
		submenu_data[#items] = menu_data[#items]
		submenu_data -- return
	),


	function findSavedItemIndexByTitle saved_items item_title =
	(
		found_index = 0

		if this.isArrayValue saved_items then
		(
			for item_index = 1 to saved_items.count while found_index == 0 do
			(
				if this.getSavedItemTitle saved_items[item_index] == item_title then
				(
					found_index = item_index
				)
			)
		)

		found_index -- return
	),

	function addMenuDataToCustomMenuRoot custom_root_data menu_data =
	(
		custom_items = custom_root_data[#items]
		menu_title = this.getSavedMenuTitle menu_data
		new_submenu_data = this.createSubMenuItemDataFromRootMenuData menu_data
		existing_index = this.findSavedItemIndexByTitle custom_items menu_title

		if existing_index > 0 then
		(
			custom_items[existing_index] = this.mergeSavedItemData custom_items[existing_index] new_submenu_data
		)
		else
		(
			append custom_items new_submenu_data
		)

		custom_root_data[#items] = custom_items

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
				if not (this.isCustomMenuRootData menu_data) then
				(
					append grouped_menus_data menu_data
				)
			)
		)

		if custom_root_data != undefined then
		(
			append grouped_menus_data custom_root_data
		)

		grouped_menus_data -- return
	),

	function createMenuRootDataFromCustomRootChild child_data =
	(
		child_menu_data = Dictionary #name
		child_menu_data[#version] = this.version
		child_menu_data[#id] = this.getMenuDataValue child_data #id (this.createGuidString())
		child_menu_data[#title] = this.getMenuDataValue child_data #title ""
		child_menu_data[#type] = #menu
		child_menu_data[#items] = this.getMenuDataValue child_data #items #()
		child_menu_data[#quad_context_id] = ""
		child_menu_data[#quad_modifier] = undefined
		child_menu_data[#quad_position] = undefined
		child_menu_data[#quad_menu_id] = ""
		child_menu_data[#qmnx_clear_directory] = this.qmnx_clear_directory
		child_menu_data[#clear_default_menu] = false
		child_menu_data[#quad_menus] = #()
		child_menu_data -- return
	),


	function explodeCustomMenuRootForSplitJson menus_data_array =
	(
		split_menus_data = #()
		grouped_menus_data = this.groupMenusUnderCustomMenuRoot menus_data_array

		for menu_data in grouped_menus_data do
		(
			if this.isCustomMenuRootData menu_data then
			(
				if this.hasDictValueSafe menu_data #items then
				(
					for child_data in menu_data[#items] do
					(
						append split_menus_data (this.createMenuRootDataFromCustomRootChild child_data)
					)
				)
			)
			else
			(
				append split_menus_data menu_data
			)
		)

		split_menus_data -- return
	),

	function saveMenusDataToSplitJson menus_data_array =
	(
		timer_save_split = timeStamp()
		json_io = MenuJsonIO_v()
		split_menus_data_array = this.explodeCustomMenuRootForSplitJson menus_data_array

		this.ensureSplitJsonDirectories()
		this.clearSplitJsonFiles()

		for menu_data in split_menus_data_array do
		(
			if this.isValidSavedMenuData menu_data then
			(
				json_io.saveMenusDataToJsonFile #(menu_data) (this.getSplitJsonFilePath menu_data)
			)
		)

		save_ms = ((timeStamp()) - timer_save_split)
		this.setSplitJsonCache (this.groupMenusUnderCustomMenuRoot split_menus_data_array) load_ms:0
		format "SPLIT JSON SAVE: % files in % ms\n" split_menus_data_array.count save_ms

		this.getSplitDataRootDirectory() -- return
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

	function findSavedChildMenuDataInCustomRoot menu_title custom_root_data =
	(
		found_menu_data = undefined

		if custom_root_data != undefined then
		(
			if this.hasDictValueSafe custom_root_data #items then
			(
				child_index = this.findSavedItemIndexByTitle custom_root_data[#items] menu_title

				if child_index > 0 then
				(
					found_menu_data = this.createMenuRootDataFromCustomRootChild custom_root_data[#items][child_index]
				)
			)
		)

		found_menu_data -- return
	),

	function findSavedMenuDataByTitleInArray menu_title menus_data_array =
	(
		found_menu_data = undefined
		custom_root_data = undefined
		for menu_data in menus_data_array while found_menu_data == undefined do
		(
			if this.isCustomMenuRootData menu_data then custom_root_data = menu_data
			if this.getSavedMenuTitle menu_data == menu_title then found_menu_data = menu_data
		)
		if found_menu_data == undefined then found_menu_data = this.findSavedChildMenuDataInCustomRoot menu_title custom_root_data
		found_menu_data -- return
	),


	function loadSplitMenuDataFile file_path menu_title =
	(
		found_menu_data = undefined
		if doesFileExist file_path then
		(
			json_io = MenuJsonIO_v()
			file_menus_data = json_io.loadMenusDataFromJsonFile file_path
			found_menu_data = this.findSavedMenuDataByTitleInArray menu_title file_menus_data
		)
		found_menu_data -- return
	),


	function loadSplitMenuDataByTitle menu_title =
	(
		found_menu_data = undefined
		if this.split_json_enabled then
		(
			found_menu_data = this.loadSplitMenuDataFile (this.getSplitJsonFilePathByTitle menu_title menu_type:#menu) menu_title
			if found_menu_data == undefined then found_menu_data = this.loadSplitMenuDataFile (this.getSplitJsonFilePathByTitle menu_title menu_type:#quad) menu_title
		)
		found_menu_data -- return
	),


	function findSavedMenuDataByTitle menu_title =
	(
		found_menu_data = undefined
		if this.saved_menus_data.count > 0 then found_menu_data = this.findSavedMenuDataByTitleInArray menu_title this.saved_menus_data
		if found_menu_data == undefined then if this.split_json_enabled then found_menu_data = this.loadSplitMenuDataByTitle menu_title
		if found_menu_data == undefined then found_menu_data = this.findSavedMenuDataByTitleInArray menu_title (this.loadSavedMenusDataFromJson())
		found_menu_data -- return
	),


	function createQuadDefinitionFromSavedQuadData quad_data root_menu_data =
	(
		quad_definition = MenuDefinition_v \
			type:#quad \
			title:quad_data[#title] \
			data:quad_data[#items] \
			quad_modifier:(this.getSavedQuadModifier root_menu_data) \
			quad_position:quad_data[#quad_position] \
			quad_context_id:root_menu_data[#quad_context_id] \
			manager:this \
			qmnx_clear_directory:(this.getSavedQmnxClearDirectory root_menu_data) \
			clear_default_menu:(this.getSavedClearDefaultMenu root_menu_data)

		quad_definition -- return
	),


	function createMenuDefinitionFromSavedMenuData menu_data =
	(
		definition_type = this.getSavedMenuType menu_data
		menu_definition = MenuDefinition_v type:definition_type title:(this.getSavedMenuTitle menu_data) quad_modifier:(this.getSavedQuadModifier menu_data) quad_position:(this.getMenuDataValue menu_data #quad_position undefined) quad_context_id:(this.getMenuDataValue menu_data #quad_context_id "") manager:this qmnx_clear_directory:(this.getSavedQmnxClearDirectory menu_data) clear_default_menu:(this.getSavedClearDefaultMenu menu_data)
		if definition_type == #quad and this.hasDictValueSafe menu_data #quad_menus and classOf menu_data[#quad_menus] == Array and menu_data[#quad_menus].count > 0 then
		(
			menu_definition.data = #()
			for quad_data in menu_data[#quad_menus] do append menu_definition.data (this.createQuadDefinitionFromSavedQuadData quad_data menu_data)
		)
		else menu_definition.data = menu_data[#items]
		menu_definition._data = menu_definition.data
		menu_definition -- return
	),


	function menu title type:#menu clear_default_menu:undefined qmnx_clear_directory:undefined =
	(
		if clear_default_menu == undefined then clear_default_menu = this.clear_default_menu
		if qmnx_clear_directory == undefined then qmnx_clear_directory = this.qmnx_clear_directory
		menu_definition = this.findMenuDefinitionByTitle title
		if menu_definition == undefined then
		(
			saved_menu_data = this.findSavedMenuDataByTitle title
			if saved_menu_data != undefined then
			(
				menu_definition = this.createMenuDefinitionFromSavedMenuData saved_menu_data
				if clear_default_menu then menu_definition.clear_default_menu = true
			)
			else
			(
				definition_type = this.normalizeMenuType type
				definition_quad_modifier = undefined
				definition_quad_position = undefined
				if title == "Default Viewport Quad" then (definition_type = #quad; definition_quad_modifier = #nonePressed; definition_quad_position = #TopRight)
				menu_definition = MenuDefinition_v type:definition_type title:title quad_modifier:definition_quad_modifier quad_position:definition_quad_position manager:this qmnx_clear_directory:qmnx_clear_directory clear_default_menu:clear_default_menu
			)
			append this.menus_data menu_definition
		)
		menu_definition.manager = this
		menu_definition -- return
	),


	function getQuad title clear_default_menu:false =
	(
		quad_menu_definition = this.menu title type:#quad clear_default_menu:clear_default_menu
		quad_menu_definition.manager = this
		quad_menu_definition -- return
	),


	function pasteMenuAsSingleQuad menu_title quad_title:"Default Viewport Quad" quad_position:1 quad_modifier:#nonePressed clear_default_menu:false =
	(
		global MenuBuildManager
		MenuBuildManager = this
		quad_menu_definition = this.getQuad quad_title clear_default_menu:clear_default_menu
		quad_menu_definition.quad_modifier = quad_modifier
		quad_definition = quad_menu_definition.getQuad quad_position
		quad_definition.manager = this
		quad_definition.quad_modifier = quad_modifier
		quad_definition.clearItems()
		quad_definition.addMenu menu_title flat:true
		this.waitForBuild quad_menu_definition
		quad_menu_definition -- return
	),


	function getMenuDataSignature menu_data =
	(
		signature = ""
		if this.isValidSavedMenuData menu_data then signature = ((this.getSavedMenuType menu_data as string) + "|" + (this.getSavedMenuTitle menu_data))
		signature -- return
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
		merged_items = #()

		if this.isArrayValue old_items then
		(
			for old_item in old_items do
			(
				append merged_items old_item
			)
		)

		if this.isArrayValue new_items then
		(
			for new_item in new_items do
			(
				new_item_title = this.getSavedItemTitle new_item
				old_item_index = this.findSavedItemIndexByTitle merged_items new_item_title

				if old_item_index > 0 and new_item_title != "" then
				(
					merged_items[old_item_index] = this.mergeSavedItemData merged_items[old_item_index] new_item
				)
				else
				(
					append merged_items new_item
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

		old_items = #()
		new_items = #()

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

		if this.hasDictValueSafe new_menu_data #clear_default_menu then
		(
			if new_menu_data[#clear_default_menu] == true then
			(
				merged_menu_data[#clear_default_menu] = true
			)
		)

		old_items = #()
		new_items = #()

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
			if this.getMenuDataSignature old_menu_data != "" then
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

		this.groupMenusUnderCustomMenuRoot merged_menus_data -- return
	),

	function clearJsonFile =
	(
		this.saved_menus_data = #()
		this.writeSavedMenusDataToJson #()
		format "Menu data cleared.\n"
		this.saved_menus_data -- return
	),


	function buildMenus =
	(
		if this.saved_menus_data.count == 0 then this.buildSavedMenusData()
		this.saved_menus_data -- return
	),


	function saveJsonData =
	(
		if this.saved_menus_data.count == 0 then this.buildSavedMenusData()
		this.saved_menus_data = this.groupMenusUnderCustomMenuRoot this.saved_menus_data
		if this.merge_existing_data then
		(
			old_menus_data = this.loadSavedMenusDataFromJson()
			this.saved_menus_data = this.mergeSavedMenusData old_menus_data this.saved_menus_data
		)
		saved_path = this.writeSavedMenusDataToJson this.saved_menus_data
		format "Menu data saved to:\n%\n" saved_path
		saved_path -- return
	),


	function createLegacyItemDictionaryForRebuilder ordered_items =
	(
		legacy_items = Dictionary #string

		if this.isArrayValue ordered_items then
		(
			for item_data in ordered_items do
			(
				if this.isDictionaryValue item_data then
				(
					item_id = this.getMenuDataValue item_data #id (this.createGuidString())
					legacy_item = Dictionary #name
					legacy_item[#title] = this.getMenuDataValue item_data #title ""

					if this.hasDictValueSafe item_data #items then
					(
						legacy_item[#items] = this.createLegacyItemDictionaryForRebuilder item_data[#items]
					)
					else
					(
						legacy_item[#category] = this.getMenuDataValue item_data #category ""
						legacy_item[#macro] = this.getMenuDataValue item_data #macro ""
					)

					legacy_items[item_id] = legacy_item
				)
			)
		)
		else
		(
			if this.isDictionaryValue ordered_items then
			(
				legacy_items = ordered_items
			)
		)

		legacy_items -- return
	),

	function createRebuilderCompatibleMenuData menu_data =
	(
		rebuilder_menu_data = this.cloneValue menu_data

		if this.hasDictValueSafe rebuilder_menu_data #items then
		(
			rebuilder_menu_data[#items] = this.createLegacyItemDictionaryForRebuilder rebuilder_menu_data[#items]
		)

		if this.hasDictValueSafe rebuilder_menu_data #quad_menus then
		(
			if this.isArrayValue rebuilder_menu_data[#quad_menus] then
			(
				for quad_data in rebuilder_menu_data[#quad_menus] do
				(
					if this.hasDictValueSafe quad_data #items then
					(
						quad_data[#items] = this.createLegacyItemDictionaryForRebuilder quad_data[#items]
					)
				)
			)
		)

		rebuilder_menu_data -- return
	),

	function collectDefaultQuadClearPositionsFromMenuData menu_data =
	(
		clear_positions = #()

		if this.hasDictValueSafe menu_data #quad_menus and classOf menu_data[#quad_menus] == Array and menu_data[#quad_menus].count > 0 then
		(
			for quad_data in menu_data[#quad_menus] do
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

		clear_positions -- return
	),

	function clearDefaultQuadPositionsForAllData =
	(
		clear_positions = #()
		clear_directory = this.qmnx_clear_directory

		for menu_data in this.saved_menus_data do
		(
			if (this.isDefaultQuadInjectionData menu_data) and (this.getSavedClearDefaultMenu menu_data) then
			(
				if clear_directory == "" then
				(
					clear_directory = this.getSavedQmnxClearDirectory menu_data
				)

				for position_value in (this.collectDefaultQuadClearPositionsFromMenuData menu_data) do
				(
					append clear_positions position_value
				)
			)
		)

		if clear_positions.count > 0 then
		(
			try
			(
				qmnx_clear = QuadDefaultQmnxClear_v qmnx_clear_directory:clear_directory
				qmnx_clear.clearPositions clear_positions
			)
			catch
			(
				format "QuadDefaultQmnxClear_v unavailable.\n"
			)
		)

		clear_positions -- return
	),

	function createStartupScriptText =
	(
		startup_text = ""
		startup_text += "/*\n\tAuto generated menu startup loader.\n\tCompile mode: " + ((this.getCompileMode()) as string) + "\n*/\n\n"
		startup_text += "global MenuBuildManager\n"
		startup_text += "global MenuRebuilder_qmnx_clear_guard = false\n\n"
		if this.rebuilder_file_path != "" then
		(
			startup_text += "try\n(\n"
			startup_text += "\tfileIn @\"" + this.rebuilder_file_path + "\"\n"
			startup_text += ")\ncatch\n(\n\tstartup_exception = getCurrentException()\n\tformat \"Failed to fileIn MenuBuildManager file.\\n%\\n\" startup_exception\n\tthrow\n)\n\n"
		)
		startup_text += "try\n(\n"
		startup_text += "	MenuBuildManager = MenuBuildManager_v data_file_path:@\"" + this.data_file_path + "\" native_data_file_path:@\"" + (this.getNativeDataFilePath()) + "\" compile_mode:" + ((this.getCompileMode()) as string) + " merge_existing_data:false qmnx_clear_directory:@\"" + this.qmnx_clear_directory + "\" clear_default_menu:" + (this.clear_default_menu as string) + "\n"
		startup_text += "\tsaved_menus_data = MenuBuildManager.loadSavedMenusDataFromJson()\n"
		startup_text += "\tMenuBuildManager.saved_menus_data = saved_menus_data\n"
		startup_text += "\tformat \"MenuBuildManager startup loaded % saved menus.\\n\" saved_menus_data.count\n"
		startup_text += "\tMenuBuildManager.registerCallback()\n"
		startup_text += ")\ncatch\n(\n\tstartup_exception = getCurrentException()\n\tformat \"Menu rebuild from disk failed.\\n%\\n\" startup_exception\n\tthrow\n)\n"
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

			for menu_data in this.saved_menus_data do
			(
				if this.isMenuCallbackData menu_data then
				(
					menu_rebuilder = MenuRebuilder_v menu_data:(this.createRebuilderCompatibleMenuData menu_data)
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
			ok
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
				this.clearDefaultQuadPositionsForAllData()

				for menu_data in this.saved_menus_data do
				(
					if this.isQuadCallbackData menu_data then
					(
						menu_rebuilder = MenuRebuilder_v menu_data:(this.createRebuilderCompatibleMenuData menu_data) skip_default_qmnx_clear:true
						menu_rebuilder.rebuildAsQuadMenu quad_menu_manager
					)
				)
			)

			ok
		)
	),

	function hasMenuCallbackData =
	(
		was_found = false
		for menu_data in this.saved_menus_data while not was_found do was_found = this.isMenuCallbackData menu_data
		was_found -- return
	),


	function hasQuadCallbackData =
	(
		was_found = false
		for menu_data in this.saved_menus_data while not was_found do was_found = this.isQuadCallbackData menu_data
		was_found -- return
	),


	function registerCallback =
	(
		global MenuBuildManager
		if this.saved_menus_data.count == 0 then this.saved_menus_data = this.loadSavedMenusDataFromJson()
		if this.saved_menus_data.count == 0 then this.buildSavedMenusData()
		this.saved_menus_data = this.groupMenusUnderCustomMenuRoot this.saved_menus_data
		MenuBuildManager = this
		callbacks.removeScripts id:this.callback_id
		callbacks.removeScripts id:this.quad_callback_id
		if this.hasMenuCallbackData() then callbacks.addScript #cuiRegisterMenus "MenuBuildManager.loadAllMenus()" id:this.callback_id
		if this.hasQuadCallbackData() then callbacks.addScript #cuiRegisterQuadMenus "MenuBuildManager.loadAllQuadMenus()" id:this.quad_callback_id
		ok -- return
	),


	function unregisterCallback =
	(
		callbacks.removeScripts id:this.callback_id
		callbacks.removeScripts id:this.quad_callback_id
		ok -- return
	),


	function waitForBuild menu_data =
	(
		if menu_data == undefined then format "MenuBuildManager_v.waitForBuild ignored undefined menu_data.\n"
		else
		(
			if (findItem this.wait_for_build menu_data) == 0 then append this.wait_for_build menu_data
			if (findItem this.menus_data menu_data) == 0 then append this.menus_data menu_data
		)
		menu_data -- return
	),


	function clearWaitForBuild =
	(
		this.wait_for_build = #()
		ok -- return
	),


	function applyWaitForBuildToMenusData =
	(
		for menu_data in this.wait_for_build do
		(
			if menu_data != undefined then
			(
				if (findItem this.menus_data menu_data) == 0 then
				(
					append this.menus_data menu_data
				)
			)
		)

		this.clearWaitForBuild()

		this.menus_data -- return
	),

	function waitForQuadBuild quad_menu_definition =
	(
		if quad_menu_definition != undefined then
		(
			quad_menu_definition.manager = this
			this.waitForBuild quad_menu_definition
		)

		quad_menu_definition -- return
	),

	function buildMenu menu_data =
	(
		this.waitForBuild menu_data
		this.build() -- return
	),


	function build =
	(
		format "\n"
		print "MenuBuildManager_v.build()"
		this.applyWaitForBuildToMenusData()
		this.buildMenus()
		this.saveJsonData()
		this.saveStartupScript()
		this.saved_menus_data -- return
	),


	function run =
	(
		this.build()
		if this.auto_register_callback then this.registerCallback()
		this.saved_menus_data -- return
	),


	on create do
	(
		startup_directory = this.getDefaultStartupDirectory()
		if this.data_file_path == "" then this.data_file_path = startup_directory + "\\" + this.data_file_name
		if this.startup_file_path == "" then this.startup_file_path = startup_directory + "\\" + this.startup_file_name
		if this.rebuilder_file_path == "" then this.rebuilder_file_path = this.getCurrentSourceFilePath()
		if this.native_data_file_path == "" then this.native_data_file_path = (getFilenamePath this.data_file_path) + this.native_data_file_name
		if this.native_data_io_file_path == "" then this.native_data_io_file_path = (getFilenamePath this.rebuilder_file_path) + this.native_data_io_file_name
	)
)
