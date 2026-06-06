clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../include-menus.ms" )	--"./../../include-menus.ms"
--filein( getFilenamePath(getSourceFileName()) + "/../QuadMenuManager.ms" )	--"./../QuadMenuManager.ms"

current_dir = getFilenamePath(getSourceFileName())

cfg_dir = current_dir + "/Config-Files/"

QuadMenuManager = QuadMenuManager_v blacklist:#( "*\\bak*", "*-UNUSED*", "*rollout-OPTIONS\Menus.mcr" )


QuadMenuManager.addMacrosToMenus ( cfg_dir + "/Macroscripts/" )
QuadMenuManager.addMacrosToMenus ( cfg_dir + "/Macroscripts/add_to_menu_macros.mcr" )


QuadMenuManager.quadDir ( cfg_dir + "/Quads/" )


/* IMPORT *.mcr files*/
--QuadMenuManager.convertMacroscriptsToMenus ( current_dir + "/../" ) blacklist:#( "*-UNUSED*" ) -- add to blacklist


format "\n\n"; print "========================= SETUP MENUS ========================="

/* SETUP QUAD MENUS */ 
QuadMenuManager.setupMenus() --"./../../../QuadMenus"