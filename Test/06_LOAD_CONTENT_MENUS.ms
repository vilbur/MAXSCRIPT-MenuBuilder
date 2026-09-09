clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../include-MenuManager.ms" )	--"./../include-MenuManager.ms"

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

	QUAD MENUS

================================================================================*/

/* CREATE INSTANCE FOR TESTING - FOR PRODUCTION CREATED IN "./../include-MenuManager.ms" */ 
global MENU_MANAGER_GLOBAL = MenuManager_v()


/* RESET QUADS */ 
MENU_MANAGER_GLOBAL.resetQuads() -- reset only quads



/* QUAD MENU FILES */ 
quad_cfg_files = current_dir + "/Test-Quad-Files/ModKeys"	--"./Test-Quad-Files/ModKeys"
--quad_cfg_files = current_dir + "/Test-Quad-Files/Quads-Custom"	--"./Test-Quad-Files/Quads-Custom"



MENU_MANAGER_GLOBAL.quadDir ( quad_cfg_files )


/* CREATE QUAD MENUS */ 
MENU_MANAGER_GLOBAL.createQuadMenus()



/* SUCCESS MESSAGE */ 
--messageBox "Show quad by pressing:\n\nCTRL + RMB" title:"SHOW QUAD MENU"


