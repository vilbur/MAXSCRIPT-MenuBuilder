/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle("M O D I F I E R S 1")

	ModifiersMenu = Menu_v("_Modifiers-1") flat:true


	--ModifiersMenu.addSeparator index: #( 5 )

	--QuadMenu.addSeparator index: #( 2 )
	QuadMenu.addMenu(ModifiersMenu)
)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.setTitle("M O D I F I E R S 2")

	ModifiersMenu = Menu_v("_Modifiers-2") flat:true

	--ModifiersMenu.addSeparator index:#( 3, 6 )

	QuadMenu.addMenu(ModifiersMenu)
)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle("M O D I F I E R S 3")

	ModifiersMenu = Menu_v("_Modifiers-3") flat:true
	--SplineModsMenu = Menu_v("_Modifiers-Spline") flat:true

	QuadMenu.addMenu("_Modifiers-Spline")


	--ModifiersMenu = Menu_v("_Modifiers-2") flat:true
	--
	--ModifiersMenu.addSeparator index:#( 3, 6 )

	QuadMenu.addMenu(ModifiersMenu)
)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(
	QuadMenu.setTitle("M O D I F I E R S 4")

	ModifiersMenu = Menu_v("_Modifiers-4") flat:true

	--ModifiersMenu.addSeparator index:#( 6, 8 )

	QuadMenu.addMenu(ModifiersMenu)
)



/** DEFIEN QUAD
  */
QuadMenuNew = QuadMenu_v( getFilenameFile( getSourceFileName() ) )


/** ADD QUAD MENUS
  */
addQuad1( QuadMenuNew.Quads[1] )
addQuad2( QuadMenuNew.Quads[2] )
addQuad3( QuadMenuNew.Quads[3] )
addQuad4( QuadMenuNew.Quads[4] )