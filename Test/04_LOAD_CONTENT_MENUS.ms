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

	QUAD MENUS

================================================================================*/


quad_cfg_files = ( getFilenamePath(getSourceFileName()) + "/Test-Quad-Files/ModKeys" )	--"./Test-Quad-Files/ModKeys"


/* QUAD MENU FILES */ 
MENU_MANAGER_GLOBAL.quadDir ( quad_cfg_files )


/* CREATE QUAD MENUS */ 
MENU_MANAGER_GLOBAL.createQuadMenus()