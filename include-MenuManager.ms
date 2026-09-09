/*
	include-MenuManager.ms
	Version: 0.90
	Release candidate main include file.
*/

if MENU_MANAGER_GLOBAL == undefined then
	global MENU_MANAGER_GLOBAL

(
	local source_directory = getFilenamePath(getSourceFileName())

	/* EXTERNAL MACROSCRIPT PARSER */
	filein (source_directory + "/../MAXSCRIPT-MacroScriptFileParser/includes.ms")


	/* LIBRARY */
	filein (source_directory + "/Lib/MenuNativeDataIO/MenuNativeDataIO.ms")
	filein (source_directory + "/Lib/QuadDefaultQmnxClear/QuadDefaultQmnxClear.ms")
	filein (source_directory + "/Lib/MenuDefinition/MenuDefinition.ms")
	filein (source_directory + "/Lib/MenuRebuilder/MenuRebuilder.ms")
	filein (source_directory + "/Lib/JsonManagerRollout/JsonManagerRollout.ms")
	filein (source_directory + "/Lib/MenuBuildManager/MenuBuildManager.ms")
	filein (source_directory + "/Lib/ParsedMenusData/ParsedMenusData.ms")
	filein (source_directory + "/Lib/ConfigFilesBlacklist/ConfigFilesBlacklist.ms")


	/* MAIN MANAGERS */
	filein (source_directory + "/MenuManager/MenuManager.ms")
	filein (source_directory + "/MenuManagerUI/MenuManagerUI.ms")
)


/* CREATE GLOBAL INSTANCE */
MENU_MANAGER_GLOBAL = MenuManager_v()