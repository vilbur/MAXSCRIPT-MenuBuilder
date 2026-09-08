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
--macro_scripts_file =  current_dir + "/../Config-Files/Test/Menus/MacroScriptsToMenus.mcr"	--"./../Config-Files/Test/Menus/MacroScriptsToMenus.mcr"
--macro_scripts_file =  ( getFilenamePath(getSourceFileName()) + "/Macros-Parser-Test-Files/MENU A.mcr" )	--"./Macros-Parser-Test-Files/MENU A.mcr"
macro_scripts_file =  ( getFilenamePath(getSourceFileName()) + "/Macros-Parser-Test-Files" )	--"./Macros-Parser-Test-Files"

/* CREATE INSTANCE FOR TESTING - FOR PRODUCTION CREATED IN "./../include-QuadMenuManager.ms" */ 
global MENU_MANAGER_GLOBAL = QuadMenuManager_v()


/* ADD MACORS TO MENUS */ 
MENU_MANAGER_GLOBAL.addMacrosToMenus (macro_scripts_file)
--appendIfUnique MENU_MANAGER_GLOBAL.macroscripts_to_import macro_scripts_file
		
		
--format "MENU_MANAGER_GLOBAL.macroscripts_to_import: %\n" MENU_MANAGER_GLOBAL.macroscripts_to_import
--format "MENU_MANAGER_GLOBAL.macroscripts_to_import.count: %\n" MENU_MANAGER_GLOBAL.macroscripts_to_import.count
-- MENU_MANAGER_GLOBAL.macroscripts_to_import.count: 1

--format "MENU_MANAGER_GLOBAL.MenuBuildManager.menus_data: %\n" MENU_MANAGER_GLOBAL.MenuBuildManager.menus_data


--for menu_data in MENU_MANAGER_GLOBAL.MenuBuildManager.menus_data do
	--format "MENU_DATA: %\n" menu_data

-- MENU_MANAGER_GLOBAL.menus_data.keys: #("_TEST MENU A", "_TEST MENU B")

--format "MENU_MANAGER_GLOBAL.menus_data: %\n" MENU_MANAGER_GLOBAL.menus_data
--MENU_MANAGER_GLOBAL.menus_data: (Dictionary #string (DataPair "_TEST MENU A" #(#("_TEST MENU A", "_test_macro_A1", "Test Macro Button Text"))) (DataPair "_TEST MENU B" #(#("r_GLOBAL.menus_data.keys do

		
		
		
		
createDialog MenuManagerUI_ROLLOUT width:380 --1024



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

