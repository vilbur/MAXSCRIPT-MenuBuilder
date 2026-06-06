filein( getFilenamePath(getSourceFileName()) + "/MacroScriptFileParser/MacroScriptFileParser.ms" )	--"./MacroScriptFileParser/MacroScriptFileParser.ms"


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
	MenuBuildManager = MenuBuildManager_v(),
	
	/* reference */
	/* inhered */
	/* static */ 
	hotkeys = #( #RightClick, #shiftPressed, #altPressed, #controlPressed, #shiftAndAltPressed, #shiftAndControlPressed, #controlAndAltPressed, #shiftAndAltAndControlPressed ),
	/** Setup menus by config files in dir
	  * 
	  * NOTE: hotkey of DEFAULT QUAD is set to CTRL+SHIFT+AL+RMB
	  * 
	 */
	function setupMenus =
	(
		--format "\n"; print "QuadMenuManager_v.setupMenus()"
		
		/* filein *.mcr files and create menus from them */ 
		macroscript_files_allowed = for macroscript_file in this.macroscript_to_import where not this.isOnBlacklist macroscript_file blacklist collect macroscript_file

		this._fileInMacroscriptFiles( macroscript_files_allowed )
		
		/*------------------------------------------------------------------------------
			MENUS DATA
		--------------------------------------------------------------------------------*/
		this._setMenusData( macroscript_files_allowed )
		
		/*------------------------------------------------------------------------------
			MENUS
		--------------------------------------------------------------------------------*/
		this._createMenus()
		
		/*------------------------------------------------------------------------------
			QUADS
		--------------------------------------------------------------------------------*/
		this._createQuads(this._getQuadConfigFiles())
		
		/* ISNTALL QUAD MENUS */ 
		--this.setDefaultQuadHotkey(#shiftAndAltAndControlPressed)

		--this._convertMacroscriptsToMenus()

		--this._fileInMacroscriptFiles()	--"./../../../QuadMenu/QuadMenus"
		
		
		--this._reconnectHotkeys()
	),
	
	/** Add macros to menus
	 */
	function addMacrosToMenus macroscript_paths =
	(
		--format "\n"; print "QuadMenuManager_v.addMacrosToMenus()"
		
		if classOf macroscript_paths != Array then
			macroscript_paths = #(macroscript_paths)
		
		for macroscripts_path in macroscript_paths where doesFileExist macroscripts_path do
		(
			
			if doesDirectoryExist macroscripts_path then
			(
				for file_path in getFiles macroscripts_path do 
					appendIfUnique this.macroscript_to_import file_path
			)
			else
				appendIfUnique this.macroscript_to_import macroscripts_path
			
		)
	),
	
	
	/** Add dir
	 */
	function quadDir dirs =
	(
		format "\n"; print "QuadMenuManager_v.addDir()"
		if classOf dirs != Array then
			dirs = #(dirs)
			
		for dir in dirs do
			appendIfUnique this.quad_dirs dir
	),
	

	

	
	private
	
	function isOnBlacklist macroscript_file blacklist = ((for pattern in blacklist where matchPattern macroscript_file pattern:pattern collect pattern).count > 0),
	
	/** Import macroscript files to menus
	 */
	function _setMenusData macroscript_files_allowed =
	(
		--format "\n"; print "QuadMenuManager_v._setMenusData()"
		--format "dir: %\n" dir
		format "\n"; print "QuadMenuManager_v.addDir()"
		

		for macroscript_file in macroscript_files_allowed where findItem parsed_macroscript_files macroscript_file == 0 do
		( 
			format "CREATE MENUS FROM FILE: %\n" (filenameFromPath(macroscript_file))
			
			appendIfUnique parsed_macroscript_files macroscript_file
			
			MacroScriptFileParser = MacroScriptFileParser_v macroscript_file
			format "MacroScriptFileParser.MacroScripts: %\n" MacroScriptFileParser.MacroScripts.count
			
			if MacroScriptFileParser.MacroScripts.count > 0 then
			(
				for _MacroScript in MacroScriptFileParser.MacroScripts where ( item_data =  this._getMenuData _MacroScript ) != undefined do
				(
					menu_name = item_data[1] -- menu name is category of macroscript  
					
					if menus_data[menu_name] == undefined then
						menus_data[menu_name] = #()
					
					appendIfUnique menus_data[menu_name] item_data
				)
			)
		)
			--catch
				--FORMAT "!!!!! FILEIN *.mcr file ERROR\n\n%\n\n" (getCurrentException())
	),
	
	/** Createa menus
	 */
	function _createMenus =
	(
		--format "\n"; print "QuadMenuManager_v._createMenus()"
		
		for menu_name in menus_data.keys do
		(
			menu_new = MenuBuildManager.menu (menu_name) --type:#quad
		
			for menu_item_data in menus_data[menu_name] do
				menu_new.addItem menu_item_data[1] menu_item_data[2] title:menu_item_data[3]
		)
		
		
	),
	
	/*
	
	
		@return #( macro_category, macro_name, title )
	*/ 
	function _getMenuData _MacroScript =
	(
		--format "\n\n"; print "ScriptFile_Content_v._getMenuData()"
		
		if (menu_name_param = _MacroScript.Params[#menu]) != undefined or (classOf menu_name_param == BooleanClass and menu_name_param == true) then
		(
			
			title = case of
			(
				(menu_name_param	== true ): case of
				(
					(_MacroScript.buttontext	!= undefined):	_MacroScript.buttontext
					(_MacroScript.tooltip	!= ""):	_MacroScript.tooltip
					
					default: _MacroScript.macro_name
				)
				
				(menu_name_param as name	== #TOOLTIP ):	if _MacroScript.tooltip != undefined then _MacroScript.tooltip else _MacroScript.buttontext
				
				default: 	menu_name_param
			)
	
			#( _MacroScript.category, _MacroScript.macro_name, title ) --return
			
		)
	),

	/** Get macroscript files
	 */
	function _getQuadConfigFiles =
	(
		--format "\n"; print "QuadMenuManager_v._getQuadConfigFiles()"
		quad_cfg_files = #()

		/** Test if path is on blacklist
		 */

		for dir in this.quad_dirs do
		(
			quad_config_files = getFiles ( dir + "/*.ms" ) recurse:true  -- "./../../slot_properties.ini"
			
			----for quad_config_file in quad_config_files where not isOnBlacklist quad_config_file blacklist do
			for quad_config_file in quad_config_files do
				appendIfUnique quad_cfg_files quad_config_file
		)
		
		quad_cfg_files --return
	),

	/** Get blacklist
	 */
	function _getAddToBlacklist blacklist =
	(
		--format "\n"; print "QuadMenuManager_v._getAddToBlacklist()"
		if blacklist != undefined then
		(
			if classOf blacklist != Array then
				blacklist = #(blacklist)
			
			blacklist = makeUniqueArray ( this.blacklist + blacklist )
		)
		
		blacklist --return
	),
	
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
		format "\n"; print "QuadMenuManager_v._fileInMacroscriptFiles()"
		
		for macroscript_file in macroscript_to_import do
		(
			macroscript_file = pathConfig.normalizePath macroscript_file
			
			--menu_name = getFilenameFile( macroscript_file )
	
			FORMAT "\n\n============================== SETUP QUAD MENU FILE ==========================================\n%\n" (getFilenameFile( macroscript_file ))
		
			filein( macroscript_file )
		)
	),
	
	
	/** Setup quad configs
	 */
	function _createQuads quad_cfg_files =
	(
		format "\n"; print "QuadMenuManager_v._createQuads()"
		
		
		for quad_cfg_file in quad_cfg_files do
		(
			
			configQuad1 = undefined
			configQuad2 = undefined
			configQuad3 = undefined
			configQuad4 = undefined
			
			filename = getFilenameFile(quad_cfg_file)
			format "QUAD_CFG_FILE: %\n" quad_cfg_file
			QuadMenuNew = MenuBuildManager.menu filename type:#quad
			--format "QuadMenuNew: %\n" QuadMenuNew

			filein quad_cfg_file
			
			/* SET MODIFIER KEYS */ 
			if ( mod_keys_by_filename = _normalizeQuadModifier filename ) != undefined then 
				QuadMenuNew.quad_modifier = mod_keys_by_filename
			--testCall( QuadMenuNew.quad "QUAD 1" )
			
			if configQuad1 != undefined then configQuad1( QuadMenuNew.getQuad 1 )
			if configQuad2 != undefined then configQuad2( QuadMenuNew.getQuad 2 )
			if configQuad3 != undefined then configQuad3( QuadMenuNew.getQuad 3 )
			if configQuad4 != undefined then configQuad4( QuadMenuNew.getQuad 4 )			
		)
		
		/* BUILD AND INSTALL MENUS AND QUAD MENUS */ 
		MenuBuildManager.installMenusNow update_quads:true load_default_cui_configuration:true
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
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
