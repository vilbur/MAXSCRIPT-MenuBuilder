/* IMPORT PARSER of .mcr files */ 
filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-MacroScriptFileParser/includes.ms" )	--"./../MAXSCRIPT-MacroScriptFileParser/includes.ms"

/*
	include-QuadMenuManager.ms
	Version: 0.90
	Release candidate main include file.
*/

global MENU_MANAGER_GLOBAL

/* IMPORT FILES */ 
--filein( getFilenamePath(getSourceFileName()) + "/MacroscrpitsToMenuConvertor/MacroscrpitsToMenuConvertor.ms" )	--"./MacroscrpitsToMenuConvertor/MacroscrpitsToMenuConvertor.ms"

filein( getFilenamePath(getSourceFileName()) + "/QuadMenuManager/QuadMenuManager.ms" )	--"./QuadMenuManager/QuadMenuManager.ms"


/* CREATE GLOBAL INSTANCE */ 
MENU_MANAGER_GLOBAL = QuadMenuManager_v()