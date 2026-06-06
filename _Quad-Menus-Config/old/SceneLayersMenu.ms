/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle("M O V E")

	--FooMenu	= Menu_v("Selection")
	--FooMenu.removeItem()
	--FooMenu.clearSeparators()


	QuadMenu.addMenu("_SceneLayers-Select")	title:"&Select"	flat:false --separators: #( 1 ) --index:--index:--index:

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_SceneLayers-Move")	title:"&Move To"	flat:false --separators: #( 1 ) --index:--index:--index:
	QuadMenu.addMenu("_SceneLayers-Copy")	title:"&Copy To"	flat:false --separators: #( 1 ) --index:--index:--index:

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_SceneLayers-Instance")	title:"&Instance To"	flat:false --separators: #( 1 ) --index:--index:--index:
	QuadMenu.addMenu("_SceneLayers-Reference")	title:"&Reference To"	flat:false --separators: #( 1 ) --index:--index:--index:
)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.setTitle("M A N A G E" )
	QuadMenu.addMenu("_SceneLayers-Manage")	--title:""	flat:false --separators: #( 1 ) --index:--index:--index:

)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	--QuadMenu.setTitle("I N S T A N C E")
	QuadMenu.setTitle("V I S I B I L I T Y")

	QuadMenu.addMenu("_SceneLayers-Visibility")	--title:""	flat:false --separators: #( 1 ) --index:--index:--index:
)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(

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