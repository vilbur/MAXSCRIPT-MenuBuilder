/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle("Edit 1")

	/* EDIT POLY */
	QuadMenu.addMenu("_Epoly-Constraints")  --separators: #( 1 )

	QuadMenu.addMenu("_Epoly-Tools-Options") separators: #( 1 )

	
	
	/* EDIT SPLINE TOOLS MENU */

	QuadMenu.addItem ("Editable Spline Object") ("Divide (Spline)")   group:"Main UI" --index:1
	QuadMenu.addItem ("Editable Spline Object") ("Connect (Spline)")  group:"Main UI" --index:1

	--SplineToolsMenu = menu_v("Context Spline Tools 4")
	--QuadMenu.addSeparator()

	QuadMenu.addMenu("Context Spline Tools 4")

	/* CONVERT TO */
	--QuadMenu.addSeparator()

	--QuadMenu.addItem ("Modifier Stack") ("Convert To Editable Polygon") group:"Main UI" --index:1

	QuadMenu.addMenu("_Object-ConvertTo") separators: #( 1 ) --"./../VilTools/rollouts-Tools/rollout-OBJECT/CONVERT_TO.mcr"
	
	--QuadMenu.clearSeparators()


)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.setTitle("Edit 2")

	/* EDIT POLY */
	QuadMenu.addMenu("_Epoly-Connect") separators: #( 2, 3 )

	QuadMenu.addMenu("_Epoly-Edit")	 separators: #( 1 ) --flat:false 	-- "./../../VilTools/rollouts-Tools/rollout-EDIT-POLY/EDIT.mcr"

	QuadMenu.addMenu("_Epoly-Edges")	title:"Edges" separators: #( 1 )	--flat:false

	/* EDIT SPLINE */
	--QuadMenu.addMenu("Context Spline Tools 2")
	SplineToolsMenu = menu_v("Context Spline Tools 2")

	--SplineToolsMenu.removeItem #{ 5, 7, 10..13 }
	SplineToolsMenu.removeItem #{10..13}

	QuadMenu.addMenu(SplineToolsMenu)

)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle("Edit 3")


	/* EDIT POLY */
	QuadMenu.addMenu("_Epoly-Object") separators: #( 1, 3 )	--flat:false

	--QuadMenu.addSeparators #( 1 )

	/* EDIT SPLINE */
	--SplineToolsMenu = QuadMenu.addMenu("Context Spline Tools 2") --separators: #( 1 )	--flat:false --index:1
	--QuadMenu.addItem ("Weld Vertices (Spline)") ("Editable Spline Object") group:"Main UI" --index:1
	SplineToolsMenu = menu_v("Context Spline Tools 3")

	SplineToolsMenu.addItem ("Editable Spline Object") ("Weld Vertices (Spline)")  group:"Main UI" --index:1
	SplineToolsMenu.addItem ("Editable Spline Object") ("Fuse Vertices (Spline)")  group:"Main UI" --index:1
	SplineToolsMenu.addItem ("Editable Spline Object") ("Break Vertices (Spline)") group:"Main UI" --index:1

	QuadMenu.addMenu(SplineToolsMenu)

	--QuadMenu.addItem ("ESpline_Weld") ("Editable Spline Object") group:"Main UI" --index:1

	--SplineToolsMenu = QuadMenu.addMenu("Context Spline Tools 1") separators: #( 1 )	--flat:false --index:1
	--SplineToolsMenu.removeItem ( for i = 1 to 8 collect i  )

	--SplineToolsMenu.clearSeparators()

)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(
	QuadMenu.setTitle("EDIT 4")

	/* EDIT POLY */
	QuadMenu.addMenu("_Epoly-Tools-Main") separators: #( 2, 6 )

	QuadMenu.addMenu("_Epoly-PolyTools") separators: #( 1 )

	/* EDIT SPLINE */
	SplineToolsMenu = QuadMenu.addMenu("Context Spline Tools 1") --separators: #( 1 )	--flat:false --index:1

	--SplineToolsMenu.removeItem(1) -- remove submenu "Edit/Editable Spline Menu"

	SplineToolsMenu.removeItem ("Divide")

	--SplineToolsMenu.addSeparator index:1
	--SplineToolsMenu.removeItem("Bind")
	--SplineToolsMenu.removeItem("Unbind")
	SplineToolsMenu.clearSeparators()

	--QuadMenu.clearSeparators()
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
