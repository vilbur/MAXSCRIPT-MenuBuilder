/** Macro file to menu convertor
 */
struct MacroscrpitsToMenuConvertor_v
(
	/* construct */
	
	/* required */
	
	/* properties */
	
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */

	/** Add macroscripts to menus
	  
		@param struct MacroScripts --"./../../MAXSCRIPT-MacroScriptFileParser/MacroScript/MacroScript.ms"
	  
	 */
	function addMacroscriptsToMenus MacroScripts =
	(
		--format "\n"; print "MacroscrpitsToMenuConvertor_v.addMacroscriptsToMenus()"
		for _MacroScript in MacroScripts do 
			this._addToMenu (_MacroScript)
	),
	
	/** ADD TO MENU
	  
	  
	 */
	function _addToMenu _MacroScript =
	(
		--format "\n"; print "ScriptFile_Content_v._addToMenu()"
		
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
	

	/**
	 */
	on create do
	(
		--format "\n"; print "MacroscrpitsToMenuConvertor.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
