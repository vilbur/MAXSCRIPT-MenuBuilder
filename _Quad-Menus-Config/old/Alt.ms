/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle("E D I T 1")


	QuadMenu.addMenu("_Epoly-Options") separators: #( 3 )	--flat:false
	
)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.setTitle("E D I T 2")

	QuadMenu.addMenu("_Epoly-Hard-Edges")	title:"H A R D - E D G E S" separators: #( 1 ) --flat:false
	
	QuadMenu.addSeparator()


)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle("E D I T 3")

	QuadMenu.addMenu("_Epoly-Explode") title:"E X P L O D E" flat:false

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Epoly-Edit-Dialogs")  separators: #( 1, 3 )	--flat:false

)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(
	QuadMenu.setTitle("E D I T 4")

	--QuadMenu.addMenu("_Epoly-Vertex-Color-Tools") --title:"" flat:false
	--QuadMenu.addSeparator()

	QuadMenu.addMenu("_Epoly-Selection") --separators: #( 1, 2 )
	
	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Epoly-Loop-Tools") separators: #( 1, 2 )

)

/** DEFIEN QUAD
  */
QUAD_MENU = QuadMenu_v( getFilenameFile( getSourceFileName() ) )


/** ADD QUAD MENUS
  */
addQuad1( QUAD_MENU.Quads[1] )
addQuad2( QUAD_MENU.Quads[2] )
addQuad3( QUAD_MENU.Quads[3] )
addQuad4( QUAD_MENU.Quads[4] )