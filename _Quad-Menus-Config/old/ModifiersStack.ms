/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle("M O D - S T A C K  1")

	_ModifiersManage = QuadMenu.addMenu("_Modifiers-Manage") separators: #( 2, 3, 5 ) 	--flat:false --index:1


	--QuadMenu.addMenu("")

	--QuadMenu.addSeparator index:1
	--QuadMenu.addSeparator()
	--_ModifiersManage.addSeparators #(3,5)
)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.setTitle("M O D - S T A C K  2")

	--NameMenu 	= Menu_v("_Modifiers-Name")

	--NameMenu.addSeparators #( 4 )

	--QuadMenu.addMenu(NameMenu)	--flat:false --index:1

	QuadMenu.addMenu("_Modifiers-Name")	separators: #( 3, 4 ) --flat:false --index:1


)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle("M O D - S T A C K  3")

	QuadMenu.addMenu("_Modifiers-Remote-Stack")	--flat:false --index:1

)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(
	QuadMenu.setTitle("M O D - S T A C K  4")

	QuadMenu.addMenu("_Modifiers-Gizmo")
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