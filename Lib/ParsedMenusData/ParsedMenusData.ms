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
	
	menu_name, -- store last used menu
	menu_data, -- store last used menu
	
	/* dependency */
	/* reference */
	/* inhered */
	
	/** Add to menu data
	 */
	function addMacroscripFilesToMenus =
	(
		FORMAT "\n\n"; print "========================= PARSE MENUS ========================="
		format "\n"; print "ParsedMenusData_v.addMacroscripFilesToMenus()"
		format "% .mcr files will be parsed to menus\n" macroscripts_to_import.count
		
		/* PARSE mcr FILES */ 
		for macroscript_file in macroscripts_to_import do
		(
			MacroParser 	= MacroScriptFileParser_v (macroscript_file)
			
			/* PASRSE macroscripts in mcr file */ 
			for _MacroScript in MacroParser.MacroScripts where _MacroScript.isMenuItem() do
				this.addItemToMenu (_MacroScript.category) (_MacroScript.macro_name) (_MacroScript.getTitle())  --return
		)
	),
	
	/** Add item to menu
	 */
	function addItemToMenu macro_category macro_name title =
	(
		--format "\n"; print "MenuManager_v.addItemToMenu()"
		--menu_name = item_data[1] -- menu name is category of macroscript
		
		/* GEN NEW MENU DATA ONLY IF NEW MENU OCCURES */ 
		if macro_category != this.menu_name then
			this.menu_data = this._getDataOfMenuByName macro_category
		
		/* ADD MACRO TO MENU */ 
		append this.menu_data #( macro_category, macro_name, title )
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
	

	/**
	 */
	on create do
	(
		--format "\n"; print "ParsedMenusData.onCreate()"
		this.addMacroscripFilesToMenus()
	)
)