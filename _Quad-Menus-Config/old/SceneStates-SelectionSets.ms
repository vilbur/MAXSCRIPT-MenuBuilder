/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle("SELECTION SETS")

	--FooMenu	= Menu_v("_Selection-Sets")
	--FooMenu.removeItem()
	--FooMenu.clearSeparators()

	QuadMenu.addItem "_Selection-Sets" "selection_sets_select" title:"&SELECT"

	--QuadMenu.addSeparator()
	
	--Menu.moveItem ("ITEM") 1

	--QuadMenu.addSeparators #()


)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.setTitle("MANAGE SETS")
	
	QuadMenu.addMenu("_Selection-Sets")	separators: #(  2, 4, 6 )	--title:"" --index: --flat:false
)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle("S C E N E   S T A T E S")
	
	QuadMenu.addMenu("_Scene-States")	--separators: #(  4, 6 )	--title:"" --index: --flat:false
	
	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Scene-States-Parts")	--separators: #(  4, 6 )	--title:"" --index: --flat:false
	
	QuadMenu.addSeparator()
	
	QuadMenu.addMenu("_Scene-States-IO")	--separators: #(  4, 6 )	--title:"" --index: --flat:false
)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(
	--QuadMenu.setTitle("LOAD|SAVE|RENAME|DELETE")
	QuadMenu.setTitle("S C E N E  S T A T E")
	--QuadMenu.setTitle("CTRL:save|SHIFT:rename|ALT:Delete")

	_SceneStatesMenu = QuadMenu.addMenu("_Scene-States-Manage")	--separators: #(  4, 6 )	--title:"" --index: --flat:false
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