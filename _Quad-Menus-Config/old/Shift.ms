/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle(" S N A P")

	SnapQuadMenu 	= QuadMenu_v("Snap") -- Get Quad Menu "Snap"

	SnapMenu	= SnapQuadMenu.getMenu(#BOTTOM_RIGHT)
	SnapOptionsMenu	= (QuadMenu_v("Snap")).getMenu(#TOP_LEFT)

	item_1 = SnapOptionsMenu.getItem 1
	--format "item_1: %\n" item_1
	
	(SnapOptionsMenu.getItem 1).setTitle ("Snap AXIS Constraints")
	(SnapOptionsMenu.getItem 2).setTitle ("Snap To FROZEN objects")
	
	SnapOptionsMenu.removeItem 4
	
	/* REORDER ITEMS */
	SnapMenu.moveItem ("Pivot") 4
	
	
	/* ADD MENUS */
	QuadMenu.addMenu( SnapOptionsMenu )	-- index:3 --flat:true
	
	QuadMenu.addSeparator()
	
	QuadMenu.addMenu( SnapMenu )	 --index:1 --flat:true

)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.setTitle("C O O R D S Y S")

	SnapSubmenu = menu_v("Coordinate System")

	SnapSubmenu.moveItem("World")(2)
	SnapSubmenu.moveItem("Parent")(3)
	SnapSubmenu.moveItem("Local Aligned")(7)

	QuadMenu.addMenu(SnapSubmenu)
)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle("P I V O T")

	QuadMenu.addMenu("_Pivot")	separators: #( 3, 5 )	--title:"" --index: --flat:false
)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(
	QuadMenu.setTitle("T R A N S F O R M")

	QuadMenu.addMenu("_Transform")	separators: #( 3 ) --flat:false --index:1
	QuadMenu.addMenu("_Transform-Lock")	separators: #( 1, 4 ) --flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Transform-Align")	--separators: #( 1, 4 ) --flat:false --index:1

	--QuadMenu.addMenu("MenuName")	--flat:true --index:1
	--QuadMenu.addMenu(DefaulQuadMenu.menu)	--flat:true --index:1
	--QuadMenu.addItem ("Category") ("macroscript_nmae") index:1

	--QuadMenu.addItem ("Snaps") ("Enable Axis Constraints in Snaps Toggle") 	group:"Main UI" --title:"Axis Snap"
	--QuadMenu.addItem ("Snaps") ("Snaps To Frozen Objects Toggle") 	group:"Main UI" --title:"Snap To Frozen Objects"
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