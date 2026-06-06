/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle("S W I T C H   V I E W P O R T")

	--Fooo	= Menu_v("")

	--QuadMenu.addMenu("")

	--QuadMenu.addSeparator index:1
	--QuadMenu.addSeparator()
	--QuadMenu.addSeparators #()
)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(v
	QuadMenu.setTitle("L A Y O U T   L O A D" )
	
	LayoutsMenu 	= QuadMenu.addMenu("_Viewports-Layout")
	--LayoutsMenu 	= Menu_v("_Viewports-Layout")

	LayoutsMenu.addSeparator()
	
	/* ALL LAYER PRESETS */ 
	----LayoutsPresetMenu 	= QuadMenu.addMenu("_Viewports-Layout-Preset")
	
	/* CHOOSE LAYER PRESETS */ 
	for layout in #( #restore_layout_4, #restore_layout_2v, #restore_layout_2h, #restore_layout_3vl, #restore_layout_3ht, #restore_layout_4vl  ) do
		LayoutsMenu.addItem ("_Viewports-Layout-Preset") ( layout as string )
		
	--LayoutsMenu.moveItem ("QUICK Layout") 1

	--LayoutsMenu.addSeparators #( 2, 3, 5, 7 )
	LayoutsMenu.addSeparators #( 2, 4, 6, 8 )
)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle("M A N A G E   L A Y O U T")

	LayoutsMenu 	= Menu_v("_Viewports-Manage")

	LayoutsMenu.addSeparators #( 3 )

	QuadMenu.addMenu( LayoutsMenu )	--flat:true --index:1
	
	QuadMenu.addSeparator()

	QuadMenu.addMenu( "_Viewports-HUD" )	--flat:true --index:1
	
	QuadMenu.addSeparator()
	
	QuadMenu.addMenu( "_Viewports-Setup" )	--flat:true --index:1
)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(
	QuadMenu.setTitle("OPTIONS")
	
	
	/* REMOVE DEFAULT ITEMS FROM END OF MENU */ 
	if (items_count = QuadMenu.numItems()) == 15 then
		for i = items_count to items_count - 6 by -1 do
			QuadMenu.removeItem(i)
			
	QuadMenu.addSeparator()

	QuadMenu.addMenu( "_Viewports-Setup-Grid" )	--flat:true --index:1
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