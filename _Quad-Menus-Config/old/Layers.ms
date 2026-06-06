/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle("HIDE LAYERS")

	Layers1Menu	= Menu_v("_Layers-1")

	Layers1Menu.addSeparator index:#( 2 )

	QuadMenu.addMenu(Layers1Menu)	--flat:false --index:1

	QuadMenu.addSeparator()
	
	QuadMenu.addMenu("_Layers-Wirecolor")


	--QuadMenu.addSeparator index:1
	--QuadMenu.addSeparator()
	--QuadMenu.addSeparators #()
)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.setTitle("SELECT LAYERS")


	QuadMenu.addMenu("_Layers-Select") separators:#( 2,4 )	--flat:false --index:1

	QuadMenu.addMenu(Layers2Menu)	--flat:false --index:1
)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle("MANAGE LAYERS")

	QuadMenu.addMenu("_Layers-Manage") separators:#( 2,4 )	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Layers-Dialogs")	--flat:false --index:1
)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(
	--QuadMenu.setTitle("L A Y E R S 4")
	QuadMenu.setTitle("UNHIDE LAYERS")

	LayersVisibility	= Menu_v("_Layers-Visibility")

	QuadMenu.addMenu(LayersVisibility)	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Layers-Name")	--flat:false --index:1
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