clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../include-MenuManager.ms" )	--"./../include-MenuManager.ms"

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




/* CREATE INSTANCE FOR TESTING - FOR PRODUCTION CREATED IN "./../include-MenuManager.ms" */ 
global MENU_MANAGER_GLOBAL = MenuManager_v()

/*------------------------------------------------------------------------------
	
	MACROSCRIPTS
	
--------------------------------------------------------------------------------*/

/* GET MACTOSCRIPTS IN DIR */ 
--macro_scripts_files =  current_dir + "/Macros-Parser-Test-Files" 	--"./Macros-Parser-Test-Files"
macro_scripts_files =  "C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2026 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools"


/* ADD MACOyRS TO MENUS */ 
MENU_MANAGER_GLOBAL.addMacrosToMenus (macro_scripts_files)


/*------------------------------------------------------------------------------

	QUADS

--------------------------------------------------------------------------------*/
/* COFIG FILES OF QUAD MENU */ 
--quad_cfg_files += #( current_dir + "/Test-Quad-Files/ModKeys" )	--"./Test-Quad-Files/ModKeys"
--quad_cfg_files += #( current_dir + "/Test-Quad-Files/Quads-Custom" )	--"./Test-Quad-Files/Quads-Custom`"
quad_cfg_files += #( "c:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2026 - 64bit\ENU\scripts\MAXSCRIPT-Quad-Menus-Config" )	--"./Test-Quad-Files/Quads-Custom`"

MENU_MANAGER_GLOBAL.quadDir ( quad_cfg_files )

/*------------------------------------------------------------------------------
	CREATE DIALOG MENU MANAGER UI
--------------------------------------------------------------------------------*/
		
CreateDialog MenuManagerUI_ROLLOUT

