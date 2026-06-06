/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle("M O D I F I E R S 1")

	QuadMenu.addMenu("_Modifiers-1") --separators:#( ) flat:true
)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.setTitle("M O D I F I E R S 2")

	QuadMenu.addMenu("_Modifiers-2") --separators:#( ) flat:true

)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle("M O D I F I E R S 3")

	QuadMenu.addMenu("_Modifiers-Spline")

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Modifiers-3") --separators:#( ) flat:true
)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(
	QuadMenu.setTitle("M O D I F I E R S 4")

	QuadMenu.addMenu("_Modifiers-4") --separators:#( ) flat:true
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