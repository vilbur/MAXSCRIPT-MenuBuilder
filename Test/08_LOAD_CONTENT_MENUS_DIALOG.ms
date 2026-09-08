clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../include-QuadMenuManager.ms" )	--"./../include-QuadMenuManager.ms"

quad_cfg_files = #()

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
macro_scripts_file =  current_dir + "/Macros-Parser-Test-Files" 	--"./Macros-Parser-Test-Files"

/* CREATE INSTANCE FOR TESTING - FOR PRODUCTION CREATED IN "./../include-QuadMenuManager.ms" */ 
global MENU_MANAGER_GLOBAL = QuadMenuManager_v()


/* ADD MACORS TO MENUS */ 
MENU_MANAGER_GLOBAL.addMacrosToMenus (macro_scripts_file)

		

/* COFIG FILES OF QUAD MENU */ 
quad_cfg_files += #( current_dir + "/Test-Quad-Files/ModKeys" )	--"./Test-Quad-Files/ModKeys"
quad_cfg_files += #( current_dir + "/Test-Quad-Files/Quads-Custom" )	--"./Test-Quad-Files/Quads-Custom"



MENU_MANAGER_GLOBAL.quadDir ( quad_cfg_files )

/*------------------------------------------------------------------------------
	CREATE DIALOG MENU MANAGER UI
--------------------------------------------------------------------------------*/
		
createDialog MenuManagerUI_ROLLOUT width:380 --1024


