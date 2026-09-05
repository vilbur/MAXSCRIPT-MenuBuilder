clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../include-QuadMenuManager.ms" )	--"./../include-QuadMenuManager.ms"

filein( getFilenamePath(getSourceFileName()) + "/_INCLUDE-TEST_MACROSCRIPT.mcr" )	--"./_INCLUDE-TEST_MACROSCRIPT.mcr"


/*



*/

--modifier_specs = #(
--	#("None",	"None",	#nonePressed),
--	#("Shift",	"Shift",	#shiftPressed),
--	#("Ctrl",	"Ctrl",	#controlPressed),
--	#("Alt",	"Alt",	#altPressed),
--	#("ShiftCtrl",	"Shift+Ctrl",	#shiftAndControlPressed),
--	#("ShiftAlt",	"Shift+Alt",	#shiftAndAltPressed),
--	#("CtrlAlt",	"Ctrl+Alt",	#controlAndAltPressed),
--	#("ShiftAltCtrl",	"Shift+Alt+Ctrl",	#shiftAndAltAndControlPressed)
--)
--
--

cfg_files = getFilenamePath(getSourceFileName()) + "/../Config-Files/Test"

/* CREATE INSTANCE FOR TESTING - FOR PRODUCTION CREATED IN "./../include-QuadMenuManager.ms" */ 
global MENU_MANAGER_GLOBAL = QuadMenuManager_v()

MENU_MANAGER_GLOBAL.resetMenus()

--MENU_MANAGER_GLOBAL.blacklist = #( "*\\bak*", "*-UNUSED*", "*rollout-OPTIONS\Menus.mcr" )




/*------------------------------------------------------------------------------
  
  
	MENU
	
	
--------------------------------------------------------------------------------*/
/* ADD ITEM */ 

--MENU_MANAGER_GLOBAL.addMacrosToMenus ( cfg_files + "/Menus" )	--"./../Config-Files/Test/Menus/" )


for letter in #( "A", "B", "C") do 
(
	menu_new = MENU_MANAGER_GLOBAL.menu ("_TEST_MENU_" + letter ) --type:#quad

	menu_new.addItem "_TEST_CATEGORY" "_test_macro" title:("ITEM 1 "+letter)
	
	menu_new.addItem "_TEST_CATEGORY" "_test_macro" title:("ITEM 2 "+letter)

	--menu_new.addItem("Tools")("Hide Selection")	group:"Main UI" title:"Hide SELECTED"
	
	--menu_new.addItem "_TEST_CATEGORY" "_test_macro" title:( "Time of test " + (getLocalTime())[5] as string + ":"+(getLocalTime())[6] as string )
	
)



/*------------------------------------------------------------------------------
  
  
	QUAD MENU
	
	
--------------------------------------------------------------------------------*/

--MENU_MANAGER_GLOBAL.quadDir ( cfg_files + "/Quads" )	--"./../Config-Files/Test/Quads" 
--MENU_MANAGER_GLOBAL.quadDir ( cfg_files + "/Quads/ModKeys" )	--"./../Config-Files/Test/Quads/ModKeys" 
--MENU_MANAGER_GLOBAL.quadDir ( cfg_files + "/Quads/Quads-Custom" )	--"./../Config-Files/Test/Quads/Quads-Custom" 


--for modifier_spec in modifier_specs do 
(
	quad_new = MENU_MANAGER_GLOBAL.quad ("_TEST_QUAD" ) --type:#quad
	
	quad_new.quad_modifier = #controlPressed

	
	/*------ BOTTOM LEFT QUAD ------*/
	quad_1 = quad_new.getQuad 1

	quad_1.addItem "_TEST_CATEGORY" "_test_macro" title:"ITEM 1 QUAD"
	quad_1.addSeparator()
	quad_1.addItem "_TEST_CATEGORY" "_test_macro" --title:("ITEM 2 QUAD")
	
	

	/*------ BOTTOM RIGHT QUAD ------*/
	quad_2 = quad_new.getQuad 2

	quad_2.setTitle "Custom Quad Title"
	
	quad_2.addMenu "_TEST_MENU_A" title:"MENU AS SUBMENU" separators:#(1,2) 
	
	quad_2.addSeparator()
	
	quad_2.addMenu "_TEST_MENU_B" flat:true
	
)



/*------------------------------------------------------------------------------
	CREATE MENUS
--------------------------------------------------------------------------------*/
		
--createDialog MenuManagerUI_ROLLOUT width:380 --1024


/* CREATE MENUS */ 
MENU_MANAGER_GLOBAL.createMenus()


/* CREATE QUAD MENUS */ 
MENU_MANAGER_GLOBAL.createQuadMenus()


/* SUCCESS MESSAGE */ 
--messageBox "Show quad by pressing:\n\nCTRL + RMB" title:"SHOW QUAD MENU"



