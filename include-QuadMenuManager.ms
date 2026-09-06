
/*
	include-QuadMenuManager.ms
	Version: 0.90
	Release candidate main include file.
*/

if MENU_MANAGER_GLOBAL == undefined then 
	global MENU_MANAGER_GLOBAL

/* IMPORT PARSER of .mcr files */ 
filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-MacroScriptFileParser/includes.ms" )	--"./../MAXSCRIPT-MacroScriptFileParser/includes.ms"


/* IMPORT FILES */

filein( getFilenamePath(getSourceFileName()) + "/MenusData/MenusData.ms" )	--"./MenusData/MenusData.ms"

filein( getFilenamePath(getSourceFileName()) + "/QuadMenuManager/QuadMenuManager.ms" )	--"./QuadMenuManager/QuadMenuManager.ms"

filein( getFilenamePath(getSourceFileName()) + "/MenuManagerUI/MenuManagerUI.ms" )	--"./MenuManagerUI/MenuManagerUI.ms"


/* CREATE GLOBAL INSTANCE */ 
--if MENU_MANAGER_GLOBAL == undefined then 
	MENU_MANAGER_GLOBAL = QuadMenuManager_v()