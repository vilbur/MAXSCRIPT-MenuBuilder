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
		--format "\n"; print "ParsedMenusData_v.addMacroscripFilesToMenus()"
		--format "macroscripts_to_import: %\n" macroscripts_to_import
		
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
	

	/**
	 */
	on create do
	(
		--format "\n"; print "ParsedMenusData.onCreate()"
		this.addMacroscripFilesToMenus()
	)
)