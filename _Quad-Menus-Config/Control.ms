/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle(" O B J E C T S 1")

	----format "HideMenuX	= % \n" HideMenuX
	----QuadMenu.addMenu(HideMenuX)	--flat:false --index:1
	--
	----QuadMenu.addMenu("Context Hide/Unhide Tools")	--flat:false --index:1
	----QuadMenu.addItem("Tools")("Hide_Selection")	--flat:false --index:1
	--
	----DefaultViewportQuad 	= QuadMenu_v("Default Viewport Quad")
	----
	----HideSelection = DefaultViewportQuad.Quads[2].getItem ("Hide Selection")
	----
	----format "HideSelection	= % \n" HideSelection


	QuadMenu.addItem("Tools")("Hide Selection")	group:"Main UI" title:"Hide SELECTED"
	QuadMenu.addItem("Tools")("Hide Unselected")	group:"Main UI" title:"Hide UNSELECTED"

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Visibility-Hide")	--flat:false --index:1

	--QuadMenu.addSeparator()
	--
	--QuadMenu.addMenu("_Selection-Visibility")	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addItem("Tools")("Freeze Selection")	group:"Main UI"
	QuadMenu.addItem("Tools")("Unfreeze All")	group:"Main UI"

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Selection-Object")	--flat:false --index:1
)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.setTitle("S E L E C T I O N " )


	QuadMenu.addMenu( "_Selection-Filter" ) separators:#(3)	--flat:false --index:1
	
	QuadMenu.addSeparator()
	
	QuadMenu.addMenu("_Selection-Copy")	--flat:false --index:1
	
	QuadMenu.addSeparator()
	
	QuadMenu.addMenu("_Selection-Instance")	--flat:false --index:1
	
	QuadMenu.addSeparator()
	
	QuadMenu.addMenu("_Selection-Edit")	separators:#(2) --flat:false --index:1
	
)



/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle(" O B J E C T S 3")

	ObjectNameMenu	= MenuDefinition_v title:("_Object-Name")

	QuadMenu.addMenu("_Wirecolor")	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu(ObjectNameMenu)	--flat:false --index:1
)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(
	QuadMenu.setTitle("O B J E C T S 4")

	QuadMenu.addItem("Tools")("Unhide All")	group:"Main UI" title:"UNHIDE ALL"

	QuadMenu.addMenu("_Visibility-Unhide")	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Selection-Hierarchy")	--flat:false --index:1
)
format "WTF: %\n" ( getFilenameFile( getSourceFileName() ) )

/** DEFIEN QUAD
  */
MenuBuildManager = MenuBuildManager_v()

 
QuadMenuNew = MenuBuildManager.menu ( getFilenameFile(getSourceFileName()) ) type:#quad
format "QuadMenuNew: %\n" QuadMenuNew

QuadMenuNew.quad_modifier = #ControlPressed
 
/** ADD QUAD MENUS
  */
addQuad1( QuadMenuNew.getQuad 1 )
--addQuad2( QuadMenuNew.getQuad 2 )
--addQuad3( QuadMenuNew.getQuad 3 )
--addQuad4( QuadMenuNew.getQuad 4 )

MenuBuildManager.installMenusNow update_quads:true load_default_cui_configuration:true
