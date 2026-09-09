/** Macro to menu data
  
  
 */
struct ParsedMenusData_v
(
	/* construct */
	macroscripts_to_import,
	
	/* required */
	
	/* properties */
	menus_data = Dictionary #STRING,

	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	
	/** Add to menu data
	 */
	function addMacroscripFilesToMenus =
	(
		FORMAT "\n\n"; print "========================= PARSE MENUS ========================="
		format "\n"; print "ParsedMenusData_v.addMacroscripFilesToMenus()"
		--format "macroscripts_to_import: %\n" macroscripts_to_import
		
		/* PARSE mcr FILES */ 
		for macroscript_file in macroscripts_to_import do
		(
			--format "MACROSCRIPT_FILE: %\n" macroscript_file
			MacroParser 	= MacroScriptFileParser_v (macroscript_file)

			/* PASRSE macroscript */ 
			for _MacroScript in MacroParser.MacroScripts where _MacroScript.params[#MENU] == true do
			--for _MacroScript in MacroParser.MacroScripts do
			(
				format "_MacroScript: %\n" _MacroScript.macro_name
				--format "_MacroScript: %\n" _MacroScript
				--format "_MacroScript.params: %\n" _MacroScript.params
				--format "MENU PARAM: %\n"( _MacroScript.hasParam #MENU)
				
				 --_MacroScript.hasParam #MENU
				
				title = this._getTitle (_MacroScript)
				--format "title: %\n" title
				
				
				this.addItemToMenu (_MacroScript.category) (_MacroScript.macro_name) (title)  --return
			)
		)
		
		format "MENUS_DATA.KEYS: %\n" menus_data.keys
	),
	
	/** Add item to menu
	 */
	function addItemToMenu macro_category macro_name title =
	(
		format "\n"; print "QuadMenuManager_v.addItemToMenu()"
		--menu_name = item_data[1] -- menu name is category of macroscript  
		menu_data = this._getDataOfMenuByName macro_category
		
		/* ADD MACRO TO MENU */ 
		appendIfUnique menu_data #( macro_category, macro_name, title )
	),
	
	private
	
	/** Get menu
	 */
	function _getDataOfMenuByName menu_name =
	(
		--format "\n"; print "ParsedMenusData_v._getDataOfMenuByName()"
		--format "menu_name: %\n" menu_name
		/* CREATE NEW MENU if needed */ 
		if this.menus_data[menu_name] == undefined then
			this.menus_data[menu_name] = #()
		
		this.menus_data[menu_name] --return
	),
	
	
	/** Get title
	 */
	function _getTitle _MacroScript =
	(
		--format "\n"; print "ParsedMenusData_v.getTitle()"
		if (menu_name_param = _MacroScript.Params[#menu]) != undefined then
			if menu_name_param != false then
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
		
				title --return
			)
	),
	

	/**
	 */
	on create do
	(
		--format "\n"; print "ParsedMenusData.onCreate()"
		this.addMacroscripFilesToMenus()
	)
)