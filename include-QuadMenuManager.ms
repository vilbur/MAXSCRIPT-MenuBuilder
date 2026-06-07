/*
	include-QuadMenuManager.ms
	Version: 0.90
	Release candidate main include file.
*/

global QUAD_MENU_MANAGER_GLOBAL

filein( getFilenamePath(getSourceFileName()) + "/QuadMenuManager/QuadMenuManager.ms" )	--"./QuadMenuManager/QuadMenuManager.ms"

QUAD_MENU_MANAGER_GLOBAL = QuadMenuManager_v()