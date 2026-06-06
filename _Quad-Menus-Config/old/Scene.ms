/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle("S A V E")

	--QuadMenu.addItem "File" "Save File" title:"&Save File" group:"Main UI"

	QuadMenu.addSeparator()

	
	_SaveSceneMenu = QuadMenu.addMenu("_Scene-Save")	--separators:#( 3, 5 ) --flat:false --index:1 --"./../VilTools/rollouts-Tools/rollout-SCENE/02-SAVE SCENE.mcr"
	
	QuadMenu.addSeparator()
	
	_OpenSceneMenu = QuadMenu.addMenu("_Scene-Open")	separators:#( 2, 3 ) --flat:false --index:1 --"./../VilTools/rollouts-Tools/rollout-SCENE/01-OPEN SCENE.mcr"
	
	--format "_OpenSceneMenu: %\n" _OpenSceneMenu
	--QuadMenu.addSeparator index:1
	--QuadMenu.addSeparators #()
)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.setTitle(" X-R E F")

	QuadMenu.addMenu("_Scene-Xref")	separators:#( 3 ) --flat:false --index:1
)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle("S C E N E  R E S E T")


	QuadMenu.addMenu("_Scene-Reset") separators:#(2)	--flat:false --index:1
	--QuadMenu.addSeparators #()

)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(
	QuadMenu.setTitle("OTHERS")

	QuadMenu.addMenu("_Options")	--flat:false --index:1
	
	QuadMenu.addSeparator()
	
	QuadMenu.addMenu("_Viewports-Screenshot")	--flat:false --index:1
)


format "WTF: %\n" ( getFilenameFile( getSourceFileName() ) )

/** DEFIEN QUAD
  */
QuadMenuNew = QuadMenu_v( getFilenameFile( getSourceFileName() ) )
format "QuadMenuNew: %\n" QuadMenuNew

/** ADD QUAD MENUS
  */
addQuad1( QuadMenuNew.Quads[1] )
addQuad2( QuadMenuNew.Quads[2] )
addQuad3( QuadMenuNew.Quads[3] )
addQuad4( QuadMenuNew.Quads[4] )