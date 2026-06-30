clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../include-QuadMenuManager.ms" )	--"./../include-QuadMenuManager.ms"

current_dir = getFilenamePath(getSourceFileName())

/*------------------------------------------------------------------------------
	
	USAGE OF GLOBAL QUAD MANAGER TO INSTALL QUAD MENUS 
	
	Allows to install quad menus from mutliple scripts
	
	
	Quad menu config are used to define quads and items
	
	
	1. Quad Menu = Config file -- 1 file represetns 1 Quad Menu
	
	2. FILE NAME = QUAD NAME
	
	3. FILE NAME = MODIFIER HOTKEY 	E.G.: "ControlAndAlt.ms" -- Ctrl+Alt+RMB is assigned to quad menu
	
	4. Quads are defined by methods configQuad{index} e.g.:  "Control.ms.configQuad1()" 
	
--------------------------------------------------------------------------------*/


/*==============================================================================

	CUSTOM MENUS

================================================================================*/


/* GET MACTOSCRIPTS IN FILE */ 
macro_scripts_file =  current_dir + "/../Config-Files/Test/Menus/MacroScriptsToMenus.mcr"	--"./../Config-Files/Test/Menus/MacroScriptsToMenus.mcr"


/* ADD MACORS TO MENUS */ 
MENU_MANAGER_GLOBAL.addMacrosToMenus (macro_scripts_file)
		
		
		
createDialog MenuManagerUI_ROLLOUT 420 520
		
		
--/* CREATE MENUS */ 
--MENU_MANAGER_GLOBAL.createMenus()
--
--
--
--
--
--/*==============================================================================
--
--	QUAD MENUS
--
--================================================================================*/
--
--quad_cfg_file = current_dir + "/../Config-Files/Test/Quads"	--"./../Config-Files/Test/Quads"
--
--
--/* QUAD MENU FILES */ 
--MENU_MANAGER_GLOBAL.quadDir ( current_dir + "/../Config-Files/Test" )	--"./../Config-Files/Test"
--
----filein( getFilenamePath(getSourceFileName()) + "/../Config-Files/Test/Control.ms" )	--"./../Config-Files/Test/Control.ms"
--
--
--
--/* CREATE QUAD MENUS */ 
--MENU_MANAGER_GLOBAL.createQuadMenus()

