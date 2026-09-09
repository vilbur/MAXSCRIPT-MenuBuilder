

if MenuBuildManager_v == undefined then filein( getFilenamePath(getSourceFileName()) + "/../Lib/MenuBuildManager/MenuBuildManager.ms" )	--"./../Lib/MenuBuildManager/MenuBuildManager.ms"

if ConfigFilesBlacklist_v == undefined then filein( getFilenamePath(getSourceFileName()) + "/../Lib/ConfigFilesBlacklist/ConfigFilesBlacklist.ms" )	--"./../Lib/ConfigFilesBlacklist/ConfigFilesBlacklist.ms"

global configQuad1 = undefined
global configQuad2 = undefined
global configQuad3 = undefined
global configQuad4 = undefined


/**
 * Quad menu manager.
 *
 * Converts macroscripts to menus and creates quad menus from configuration files.
 *
 * @method	addItemToMenu	macro_category macro_name title	Adds a unique macroscript action to the collected menu data.
 *
 * @method	menu	title type:#menu clear_default_menu:undefined qmnx_clear_directory:undefined	Creates or returns a menu definition managed by MenuBuildManager_v.
 *			
 * @method	quad	title clear_default_menu:false qmnx_clear_directory:undefined	Creates or returns a quad-menu definition managed by MenuBuildManager_v.
 *			
 * @method	addMacrosToMenus	macroscripts_paths	Queues one macroscript path, directory, or an array of paths for menu import.
 *			
 * @method	quadDir	quad_cfg_files	Queues one quad-config path, directory, or an array of paths.
 *	
 * @method	createMenus	which:#()	Builds collected menus and installs the current menu and quad definitions.
 *			
 * @method	createQuadMenu	()	Loads queued quad-config files, builds their quads, and installs them.
 *			
 * @method	resetAl	()	Removes all custom menus and quads, clears persisted data, and refreshes the CUI.
 *			
 * @method	resetMenus	()	Removes only normal menus and preserves quad menus.
 *			
 * @method	resetQuads	()	Removes only quad menus and preserves normal menus.
 
 
	DATA STRUCTURE OF MENUS DEFINITIONS:
 
		MenuManager.ParsedMenusData[#MENU_NAME] = MenuDefinition
 
 */
struct MenuManager_v
(
	/* construct */
	quad_dirs = #(),
	
	/* required */
	/* properties */
	menus_data = Dictionary #string,
 
	/* private */
	macroscripts_to_import = #(), -- PATHS TO *.mcr FILES with menus definition
	quad_cfg_files = #(),
	
	
	/* dependency */
	--ParsedMenusData,	--"./../Lib/ParsedMenusData/ParsedMenusData.ms"
	MenuBuildManager,	--"./../Lib/MenuBuildManager/MenuBuildManager.ms"
	Blacklist,	--"./../Lib/ConfigFilesBlacklist/ConfigFilesBlacklist.ms"
	
	/* reference */
	/* inhered */
	/* static */ 
	hotkeys = #( #RightClick, #shiftPressed, #altPressed, #controlPressed, #shiftAndAltPressed, #shiftAndControlPressed, #controlAndAltPressed, #shiftAndAltAndControlPressed ),


	/*==============================================================================
	
		CONFIG MENUS
	
	================================================================================*/

	/** ALIAS for MenuBuildManager.menu() "./../Lib/MenuBuildManager/MenuBuildManager.ms"
	  
		@return MenuDefinition_v
	 */
	function menu title type:#menu clear_default_menu:undefined qmnx_clear_directory:undefined =
	(
		--format "\n"; print "MenuManager_v.menu()"
		
		local menu_definition = this.MenuBuildManager.menu title type:type clear_default_menu:clear_default_menu qmnx_clear_directory:qmnx_clear_directory
		if menu_definition != undefined and this.MenuBuildManager.normalizeMenuType type == #menu then
			this.menus_data[menu_definition.title] = menu_definition

		menu_definition -- return
	),
	
	/*==============================================================================
	
		CONFIG QUADS
	
	================================================================================*/

	/** Quad
	 */
	/** ALIAS for MenuBuildManager.quad() "./../Lib/MenuBuildManager/MenuBuildManager.ms"
	  
	  */
	function quad title clear_default_menu:false qmnx_clear_directory:undefined =
	(
		--format "\n"; print "MenuManager_v.quad()"
		MenuBuildManager.quad title clear_default_menu:clear_default_menu qmnx_clear_directory:qmnx_clear_directory
	),
	
	/** Add .mcr files to menus
	  
	  * param string|array macroscripts_paths PATH OR PATHS TO FILES OR DIRECTORIES 
	  
	 */
	function addMacrosToMenus macroscripts_paths =
	(
		--format "\n"; print "MenuManager_v.addMacrosToMenus()"
		
			--ParsedMenusData,	--"./../Lib/ParsedMenusData/ParsedMenusData.ms"	
		/* GET PATHS TO .mcr FILES */
		macroscripts_paths = this._getPathsToFiles(macroscripts_paths) filetype:"mcr"
		
		
		/* TEST FILES BALCKLIST */ 
		macroscripts_paths = for macroscripts_path in macroscripts_paths where not Blacklist.isOnBlacklist macroscripts_path blacklist:#MENUS collect macroscripts_path
		
		
		/* REMBER MACROSCRIPT FILES - USED BY MenuManagerUI */ 
		this.macroscripts_to_import += macroscripts_paths
		
		
		/* REGISTER MACROSCRIPTS BEFORE BUILDING CUI ACTIONS */
		this._fileInMacroscriptFiles macroscripts_paths
		/* ADD MACROSCRIPTS TO MENUS */ 
		ParsedMenusData	= ParsedMenusData_v(macroscripts_paths)
		
				
		/* DEFINE MENUS FROM PARSED DATA */ 
		for menu_name in ParsedMenusData.menus_data.keys do
		(
			--format "\n"
			--format "MENU_NAME: %\n" menu_name
			--format "ParsedMenusData.menus_data[menu_name].count: %\n" ParsedMenusData.menus_data[menu_name].count
			--format "ParsedMenusData.menus_data[menu_name]: %\n" ParsedMenusData.menus_data[menu_name]
			
			local menu_new = this.menu menu_name

			for menu_item_data in ParsedMenusData.menus_data[menu_name] do
				menu_new.addItem menu_item_data[1] menu_item_data[2] title:menu_item_data[3]
			
		)
		
		--format "MENUS_DATA: %\n" menus_data
		
		--for key in menus_data.keys do
			--format "key: % \nVALUE: %\n\n" key menus_data[key]
		
	),
	
	/** Add quad configuration directory or file.
	  *
	  */
	function quadDir quad_cfg_paths =
	(
		--format "\n"; print "MenuManager_v.quadDir()"
	
		quad_cfg_paths = this._getPathsToFiles quad_cfg_paths filetype:"ms" -- return
		
		
		/* FILTER FILES BY BALCKLIST */ 
		this.quad_cfg_files += for quad_cfg_path in quad_cfg_paths where not Blacklist.isOnBlacklist quad_cfg_path blacklist:#QUADS collect quad_cfg_path
	),
		
	/** Add item to menu
	 */
	function addItemToMenu macro_category macro_name title =
	(
		--format "\n"; print "MenuManager_v.addItemToMenu()"
		
		/* ADD MACRO TO MENU */ 
		ParsedMenusData.addItemToMenu macro_category macro_name title 
	),
			
	/*==============================================================================
	
		CREATE MENUS & QUADS
	
	================================================================================*/
	
	
	/** Build menus on the same manager used by menu().

	 */
	function createMenus which:#() =
	(
		FORMAT "\n\n"; print "========================= CREATE MENUS ========================="
		format "MenuManager_v.createMenus()\n"

		local install_all = which.count == 0
		local menu_names = if install_all then this.menus_data.keys else which
		local menu_count = menu_names.count

		if install_all then
		(
			for menu_index = 1 to menu_count do
			(
				format "Installing % of % menus: %\n" menu_index menu_count menu_names[menu_index]
				try (windows.processPostedMessages()) catch()
			)

			format "Applying % menu(s) to 3ds Max. Please wait...\n" menu_count
			try (windows.processPostedMessages()) catch()
			this.MenuBuildManager.buildSavedMenusData()
			this.MenuBuildManager.installMenusNow update_quads:true load_default_cui_configuration:true
			format "Finished installing % menu(s).\n" menu_count
		)
		else
		(
			local selected_saved_data = #()

			for menu_index = 1 to menu_count do
			(
				local menu_name = menu_names[menu_index]
				format "Installing % of % menus: %\n" menu_index menu_count menu_name
				try (windows.processPostedMessages()) catch()

				local menu_definition = this.menus_data[menu_name]
				if menu_definition != undefined then
				(
					local menu_data = this.MenuBuildManager.buildSavedMenuDataFromDefinition menu_definition
					if menu_data != undefined then append selected_saved_data menu_data
				)
			)

			if selected_saved_data.count > 0 then
			(
				local selected_count = selected_saved_data.count
				this.MenuBuildManager.saved_menus_data = selected_saved_data
				format "Applying % selected menu(s) to 3ds Max. Please wait...\n" selected_count
				try (windows.processPostedMessages()) catch()
				this.MenuBuildManager.installMenusNow update_quads:true load_default_cui_configuration:true
				format "Finished installing % selected menu(s).\n" selected_count
			)
			else
			(
				format "No valid selected menus were found.\n"
			)
		)
	),

	/** SETUP MENUS BY CONFIG FILES IN DIR
	  * 
	  * NOTE: hotkey of DEFAULT QUAD is set to CTRL+SHIFT+AL+RMB
	  * 
	 */
	function createQuadMenus =
	(
		FORMAT "\n\n"; print "========================= CREATE QUAD MENU FROM QUAD AUTO CONFIG FILES ========================="
		
		
		/*------------------------------------------------------------------------------
			QUADS
		--------------------------------------------------------------------------------*/
		--this._createQuads(this._setQuadConfigFiles())
		
		--quad_cfg_files = this._setQuadConfigFiles()
		QuadBuildManager = MenuBuildManager_v()

		--this._setQuadConfigFiles()
		
		for quad_cfg_file in this.quad_cfg_files do
		(
			
			configQuad1 = undefined
			configQuad2 = undefined
			configQuad3 = undefined
			configQuad4 = undefined
			
			filename = getFilenameFile(quad_cfg_file)
			
			QuadMenuNew = QuadBuildManager.quad ("_"+filename) --type:#quad
			--QuadMenuNew = QuadBuildManager.menu ("_"+filename) type:#quad
			--QuadMenuNew = QuadBuildManager.menu (filename) type:#quad
			--format "QuadMenuNew: %\n" QuadMenuNew

			--format "\nINSTALL QUAD MENU FROM FILE: %.ms\n" filename
			
			/*==============================================================================
			
				EXECUTE QUAD CONFIG FILES
			
			================================================================================*/
			
			filein quad_cfg_file
			
			
			/*------------------------------------------------------------------------------
				 SET MODIFIER HOTKEYS KEYS E.G.: CTRL + RMB
			--------------------------------------------------------------------------------*/
			if ( mod_keys_by_filename = this._normalizeQuadModifier filename ) != undefined then 
				QuadMenuNew.quad_modifier = mod_keys_by_filename
			
			
			/*------------------------------------------------------------------------------
				MODIFY QUADS BY CODE IN FILE
			--------------------------------------------------------------------------------*/
			if configQuad1 != undefined then configQuad1( QuadMenuNew.getQuad 1 )
			if configQuad2 != undefined then configQuad2( QuadMenuNew.getQuad 2 )
			if configQuad3 != undefined then configQuad3( QuadMenuNew.getQuad 3 )
			if configQuad4 != undefined then configQuad4( QuadMenuNew.getQuad 4 )			
		)
		
		/*------------------------------------------------------------------------------
			BUILD AND INSTALL QUAD MENUS
		--------------------------------------------------------------------------------*/
		QuadBuildManager.installMenusNow update_quads:true load_default_cui_configuration:true
	),
	
	
	/*==============================================================================
		RESET MENUS & QUADS
	================================================================================*/
	
	/** Reset all custom menus and quad menus.
	  *
	  * Removes "_custom-menus" and clears the persisted .msdata file.
	  */
	function resetAll =
	(
		--format "\n"; print "MenuManager_v.resetAll()"
		MenuBuildManager = MenuBuildManager_v()

		/* REMOVE FFROM MAIN MENU */ 
		MenuBuildManager.removeMenu "_Custom-menus"
		
		/* RESET QUADS */ 
		MenuBuildManager.clearDataFile()

		/* UPDATE MENU & QUADS */ 
		MenuBuildManager.installMenusNow()
		
		--format "MenuManager: Custom menus have been reset.\n"
	),
		
	/** Reset only normal menus while preserving quad menus.
	 */
	function resetMenus =
	(
		this._resetMenuType #menu
	),

	/** Reset only quad menus while preserving normal menus.
	 */
	function resetQuads =
	(
		this._resetMenuType #quad
	),

	private

	/** Remove one definition type from memory and persisted data.
	 */
	function _resetMenuType menu_type =
	(
		local normalized_type = this.MenuBuildManager.normalizeMenuType menu_type
		local kept_saved_data = #()
		local removed_saved_data = #()
		local disk_saved_data = this.MenuBuildManager.loadSavedMenusDataFromJson()

		for menu_data in disk_saved_data do
		(
			if this.MenuBuildManager.getSavedMenuType menu_data != normalized_type then
				append kept_saved_data menu_data
			else
				append removed_saved_data menu_data
		)

		-- Loading a CUI configuration does not reliably remove roots already present
		-- in the visible menu bar, so delete persisted normal roots by GUID first.
		if normalized_type == #menu and removed_saved_data.count > 0 then
		(
			local menu_manager = this.MenuBuildManager.getCurrentCuiMenuManager()
			local menu_rebuilder_helper = MenuRebuilder_v()
			local main_menu_bar = menu_rebuilder_helper.getMainMenuBar menu_manager

			if main_menu_bar != undefined then
			(
				for menu_data in removed_saved_data do
				(
					local menu_rebuilder = MenuRebuilder_v menu_data:(this.MenuBuildManager.createRebuilderCompatibleMenuData menu_data)
					menu_rebuilder.deleteMainMenu main_menu_bar
				)
				this.MenuBuildManager.updateVisibleMenuBarNow()
			)
		)

		for definitions in #(this.MenuBuildManager.menus_data, this.MenuBuildManager.wait_for_build) do
		(
			for definition_index = definitions.count to 1 by -1 do
			(
				local definition = definitions[definition_index]
				if this.MenuBuildManager.isMenuDefinitionLike definition do
				(
					if this.MenuBuildManager.normalizeMenuType definition.type == normalized_type then
						deleteItem definitions definition_index
				)
			)
		)

		this.MenuBuildManager.saved_menus_data = kept_saved_data
		this.MenuBuildManager.writeSavedMenusDataToJson kept_saved_data
		this.MenuBuildManager.updateMenus update_quads:true
		this.MenuBuildManager.saveCurrentCuiConfiguration()
		format "Reset removed % persisted % menu(s).\n" removed_saved_data.count normalized_type

		kept_saved_data -- return
	),
	--/ParsedMenusData.** Get file paths
	--  *
	--  * @param string|array macroscript_paths to macroscript files or directories.
	--  */
	--function _setMacroscriptsToImport macroscripts_paths =
	--(
	--format "\n"; print "MenuManager_v._setMacroscriptsToImport()"
	--
	--	this._getPathsToFiles this.macroscripts_to_import macroscripts_paths -- return
	--),
	
	/** Collect .mcr files from FILES or DIRECTORIES.
	  *
	  * Adds sanitized file paths into the destination array.
	  
	  * @param filetype "ms|mcr"
	  */
	function _getPathsToFiles input_paths filetype: =
	(
		--format "\n"; print "MenuManager_v._getPathsToFiles()"
	
		destination_array = #()
	
		if classOf input_paths != Array then
			input_paths = #( input_paths )
	
		for input_path in input_paths where doesFileExist ( input_path = this._sanitizePath input_path) do
		(
			--format "Input_Path: %\n" input_path
			--format "doesDirectoryExist input_path: %\n" (doesDirectoryExist input_path)
			if doesDirectoryExist input_path then
			(
				/* GET .ms and .mcr FILES in directory */ 
				--ms_or_mcr_files = getFiles ( pathConfig.appendPath input_path "*.ms") recurse:true  + getFiles ( pathConfig.appendPath input_path "*.mcr") recurse:true
				ms_or_mcr_files = getFiles ( pathConfig.appendPath input_path ("*."+filetype) ) recurse:true 
				
				for file_path in ms_or_mcr_files do
					appendIfUnique destination_array (this._sanitizePath file_path)
			)
			else
			(
				appendIfUnique destination_array (input_path)
			)
		)
		--format "destination_array: %\n" destination_array
		destination_array -- return
	),

	/** Sanitize path
	 */
	function _sanitizePath _path =
	(
		--format "\n"; print "MenuManager_v._sanitizePath()"
		_path	= ( dotNetObject "System.Text.RegularExpressions.Regex" @"[\\/]+" ).Replace _path "\\"
		
		pathConfig.normalizePath _path--return
	),

	/** Createa menus
	 */
	function _createMenus =
	(
		format "\n"; print "MenuManager_v._createMenus()"
		
		for menu_name in ParsedMenusData.menus_data.keys do
		(
			--format "menu_name: %\n" menu_name
			menu_new = this.MenuBuildManager.menu (menu_name) --type:#quad
		
			for menu_item_data in menus_data[menu_name] do
				menu_new.addItem menu_item_data[1] menu_item_data[2] title:menu_item_data[3]
		)
		
		this.MenuBuildManager.installMenusNow()
	),

	--/** Get macroscript files
	-- */
	--function _setQuadConfigFiles =
	--(
	--	format "\n"; print "MenuManager_v._setQuadConfigFiles()"
	--	format "quad_config_files: %\n" quad_config_files
	--
	--	/** Test if path is on blacklist
	--	 */
	--
	--	for dir in this.quad_dirs do
	--	(
	--		--format "DIR: %\n" dir
	--		quad_config_files = getFiles ( dir + "/*.ms" ) recurse:true  -- "./../../slot_properties.ini"
	--		
	--		--for quad_config_file in quad_config_files where not isOnBlacklist quad_config_file blacklist do
	--		for quad_config_file in quad_config_files do
	--		(
	--			format "QUAD_CONFIG_FILE: %\n" quad_config_file
	--			appendIfUnique quad_cfg_files ( this._sanitizePath quad_config_file )
	--		)
	--	)
	--	
	--	quad_cfg_files --return
	--),

	--/** Get blacklist
	-- */
	--function _getAddToBlacklist blacklist =
	--(
	--	--format "\n"; print "MenuManager_v._getAddToBlacklist()"
	--	if blacklist != undefined then
	--	(
	--		if classOf blacklist != Array then
	--			blacklist = #(blacklist)
	--		
	--		blacklist = makeUniqueArray ( this.blacklist + blacklist )
	--	)
	--	
	--	blacklist --return
	--),
	
	/*
	Normalize quad modifier.
	Example: #shiftAndControlAndAltPressed -> #shiftAndAltAndControlPressed.
	*/
	function _normalizeQuadModifier modifier_value =
	(
		/** Join array to string
		 */
		function arrayToString arr delimeter:"" = ( _string = ""; for item in arr do _string += item as string  + delimeter; substring _string 1 (_string.count-delimeter.count))
		

		normalized_mod = undefined
		valid_mods = #("shift", "alt", "control", "none")
		modifier_string = toLower (modifier_value as string)

		if (matchPattern modifier_string pattern:"*pressed") then
			modifier_string = substring modifier_string 1 ((findString modifier_string "pressed") - 1)
		

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
	
	/** 
	  * 
	  *
	 */
	function _fileInMacroscriptFiles macroscripts_to_import =
	(
		--format "\n"; print "MenuManager_v._fileInMacroscriptFiles()"
		
		for macroscript_file in macroscripts_to_import do
			try(
			
				filein( macroscript_file )
				
			)catch(
				format "\n"; print "MenuManager_v._fileInMacroscriptFiles()"
		
				format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
				format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
			)
		
		
		--(
		--	macroscript_file = pathConfig.normalizePath macroscript_file
		--	
		--	--menu_name = getFilenameFile( macroscript_file )
		--
		--	FORMAT "\n\n============================== SETUP QUAD MENU FILE ==========================================\n%\n" (getFilenameFile( macroscript_file ))
		--
		--)
	),
	
	/** Update menus hotkeys by OPENING and CLOSING hotkey editor
	  * Workaround for reconnect of quad menus hotkeys and reinstalled quadmenus
	  * 
	  * 
	  * NOTE:
	  *	PROBLEM:  Reinstalling of quad menus break their hotkey shortcuts
	  *  	SOLUTION: Open and close hotkey editor will reconnect hotkeys and reinstalled quadmenus
	  * 
	 */
	function _reconnectHotkeys =
	(
		--format "\n"; print "MenuManager_v._reconnectHotkeys()"
		/* OPEN HOTKEY EDITOR - for refresh quad menu keyboard shortcuts */
		actionMan.executeAction 0 "59245"  -- Customize User Interface: Hotkey Editor

		/* CLOSE HOTKEY EDITOR */
		if (hotkey_dialog = (for hwnd in UIAccessor.GetPopupDialogs() where UIAccessor.GetWindowText hwnd == "Hotkey Editor" collect hwnd)[1]) != undefined then
			UIAccessor.CloseDialog hotkey_dialog
	),
	
	/**
	*/
	on create do
	(
		--format "\n"; print "MenuManager.onCreate()"
	
		Blacklist        = ConfigFilesBlacklist_v()
		MenuBuildManager = MenuBuildManager_v()
	)
)