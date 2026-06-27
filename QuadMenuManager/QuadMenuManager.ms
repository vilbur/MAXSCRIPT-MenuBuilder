

filein( getFilenamePath(getSourceFileName()) + "/../MenuBuildManager/MenuBuildManager.ms" )	--"./../MenuBuildManager/MenuBuildManager.ms"


global configQuad1 = undefined
global configQuad2 = undefined
global configQuad3 = undefined
global configQuad4 = undefined


/** Quad menu manager
  
  1) Convert Macroscripts To Menus
  
  2) Create Quads From Menus
  
 */
struct QuadMenuManager_v
(
	/* construct */
	blacklist = #(),
	
	quad_dirs = #(),
	/* required */

	/* properties */
	--blacklist_quads = #(),

	/* private */
	macroscript_to_import = #(),
	parsed_macroscript_files = #(),
	
	menus_data = Dictionary #STRING,
	
	/* dependency */
	MenuBuildManager,
	
	/* reference */
	/* inhered */
	/* static */ 
	hotkeys = #( #RightClick, #shiftPressed, #altPressed, #controlPressed, #shiftAndAltPressed, #shiftAndControlPressed, #controlAndAltPressed, #shiftAndAltAndControlPressed ),


	/** Add macros to menus
	 */
	function addMacrosToMenus macroscript_paths =
	(
		--format "\n"; print "QuadMenuManager_v.addMacrosToMenus()"
		MacroScripts_in_files = #()
		
		this._setMacroscriptsToImport(macroscript_paths)
		
		--format "macroscript_file: %\n" macroscript_file
		
		for macroscript_file in macroscript_to_import do
		(
			try(
				
				filein macroscript_file
			)catch(
				
				format "ERROR TO FILEIN FILE: %\n" macroscript_file
				
			)
			
			MacroScripts_in_file = (MacroScriptFileParser_v _path:macroscript_file).MacroScripts -- PARSE MACROSCRIPTS 	--"./MacroScriptFileParser/MacroScriptFileParser.ms"
			--format "MacroScripts_in_file: %\n" MacroScripts_in_file
			this._addMacroscriptsToMenus (MacroScripts_in_file)
			
			MacroScripts_in_files += MacroScripts_in_file
		)
		--format "MacroScripts_in_files: %\n" MacroScripts_in_files
		MacroScripts_in_files --return
	),

	/** CREATE MENUS
	 */
	function createMenus =
	(
		FORMAT "\n\n"; print "========================= CREATE MENUS ========================="

		MenuBuildManager = MenuBuildManager_v()
		--format "MenuBuildManager: %\n" MenuBuildManager
		
		--format "\n"; print "QuadMenuManager_v.createMenus()"
		for menu_name in menus_data.keys do
		(
			--format "menu_name: %\n" menu_name
			menu_new = MenuBuildManager.menu (menu_name) --type:#quad
		
			for menu_item_data in menus_data[menu_name] do
				menu_new.addItem menu_item_data[1] menu_item_data[2] title:menu_item_data[3]
		)
		
		
		MenuBuildManager.installMenusNow update_quads:true load_default_cui_configuration:true
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
		--this._createQuads(this._getQuadConfigFiles())
		
		--quad_cfg_files = this._getQuadConfigFiles()
		QuadBuildManager = MenuBuildManager_v()

		for quad_cfg_file in this._getQuadConfigFiles() do
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
			
			filein quad_cfg_file
			
			--format "configQuad1: %\n" configQuad1
			
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
		
	
	


		
	/** Add item to menu
	 */
	function addItemToMenu macro_category macro_name title =
	(
		--format "\n"; print "QuadMenuManager_v.addItemToMenu()"
		--menu_name = item_data[1] -- menu name is category of macroscript  
		
		if menus_data[macro_category] == undefined then
			menus_data[macro_category] = #()
		
		appendIfUnique menus_data[macro_category] #( macro_category, macro_name, title ) 
		
	),
	
		
	/** Add dir
	 */
	function quadDir dirs =
	(
		--format "\n"; print "QuadMenuManager_v.addDir()"
		if classOf dirs != Array then
			dirs = #(dirs)
		
		for dir in dirs do
			appendIfUnique this.quad_dirs dir
	),
	
	private
	
	/** Get file paths
	  
	  @param string|arraty macroscript_paths to macroscript files or dirs which contains .mcr files
	  
	 */
	function _setMacroscriptsToImport macroscript_paths =
	(
		--format "\n"; print "QuadMenuManager_v._setMacroscriptsToImport()"
		
		if classOf macroscript_paths != Array then
			macroscript_paths = #(macroscript_paths)
		
		for macroscripts_path in macroscript_paths where doesFileExist macroscripts_path do
		(
			/* IF DIR */ 
			if doesDirectoryExist macroscripts_path then
			(
				for file_path in getFiles macroscripts_path do 
					appendIfUnique this.macroscript_to_import file_path
			)
			/* IF MACROSCRIPT FILE */ 
			else
				appendIfUnique this.macroscript_to_import macroscripts_path
		)
	),
	
	/** Add macroscripts to menus
	  
		@param struct MacroScripts --"./../../MAXSCRIPT-MacroScriptFileParser/MacroScript/MacroScript.ms"
	  
	 */
	function _addMacroscriptsToMenus MacroScripts =
	(
		--format "\n"; print "MacroscrpitsToMenuConvertor_v._addMacroscriptsToMenus()"
		for _MacroScript in MacroScripts do 
			this._addToMenu (_MacroScript)
	),
	
	/** ADD TO MENU
	  
	  
	 */
	function _addToMenu _MacroScript =
	(
		--format "\n"; print "ScriptFile_Content_v._addToMenu()"
		--format "_MacroScript: %\n" _MacroScript
		
		if (menu_name = _MacroScript.Params[#menu]) != undefined and menu_name != false then
		(
			title = case of
			(
				(menu_name	== true ): case of
				(
					(_MacroScript.buttontext	!= undefined):	_MacroScript.buttontext
					(_MacroScript.tooltip	!= ""):	_MacroScript.tooltip
					
					default: _MacroScript.macro_name
				)
				
				(menu_name as name	== #TOOLTIP ):	if _MacroScript.tooltip != undefined then _MacroScript.tooltip else _MacroScript.buttontext
				
				default: 	menu_name
			)
	
			/*------------------------------------------------------------------------------
				ADD TO MENU
			--------------------------------------------------------------------------------*/
			MENU_MANAGER_GLOBAL.addItemToMenu (_MacroScript.category) (_MacroScript.macro_name) (title)  --return
			
		)
	),
	
	/* TEST BLACKLIST
		
		currently unsused
		
	*/ 
	----function isOnBlacklist macroscript_file blacklist = ((for pattern in blacklist where matchPattern macroscript_file pattern:pattern collect pattern).count > 0),
	
	/** Createa menus
	 */
	function _createMenus =
	(
		--format "\n"; print "QuadMenuManager_v._createMenus()"
		
		for menu_name in menus_data.keys do
		(
			--format "menu_name: %\n" menu_name
			menu_new = this.MenuBuildManager.menu (menu_name) --type:#quad
		
			for menu_item_data in menus_data[menu_name] do
				menu_new.addItem menu_item_data[1] menu_item_data[2] title:menu_item_data[3]
		)
		
		this.MenuBuildManager.installMenusNow()
	),

	/** Get macroscript files
	 */
	function _getQuadConfigFiles =
	(
		--format "\n"; print "QuadMenuManager_v._getQuadConfigFiles()"
		--format "this.quad_dirs: %\n" this.quad_dirs
		quad_cfg_files = #()

		/** Test if path is on blacklist
		 */

		for dir in this.quad_dirs do
		(
			--format "DIR: %\n" dir
			quad_config_files = getFiles ( dir + "/*.ms" ) recurse:true  -- "./../../slot_properties.ini"
			
			----for quad_config_file in quad_config_files where not isOnBlacklist quad_config_file blacklist do
			for quad_config_file in quad_config_files do
				appendIfUnique quad_cfg_files quad_config_file
		)
		
		quad_cfg_files --return
	),

	--/** Get blacklist
	-- */
	--function _getAddToBlacklist blacklist =
	--(
	--	--format "\n"; print "QuadMenuManager_v._getAddToBlacklist()"
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
	
	/** Import modify files of quad names
	  * Each quad should has its own file
	  *
	  *
	 */
	function _fileInMacroscriptFiles macroscript_to_import =
	(
		--format "\n"; print "QuadMenuManager_v._fileInMacroscriptFiles()"
		
		for macroscript_file in macroscript_to_import do
		(
			macroscript_file = pathConfig.normalizePath macroscript_file
			
			--menu_name = getFilenameFile( macroscript_file )
	
			FORMAT "\n\n============================== SETUP QUAD MENU FILE ==========================================\n%\n" (getFilenameFile( macroscript_file ))
		
			filein( macroscript_file )
		)
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
		--format "\n"; print "QuadMenuManager_v._reconnectHotkeys()"
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
		--format "\n"; print "QuadMenuManager.onCreate()"
		--MenuBuildManager = MenuBuildManager_v()
	)

)
