function configQuad1 QuadMenu =
(
	QuadMenu.setTitle("S A V E")

	QuadMenu.addSeparator()

	_SaveSceneMenu = QuadMenu.addMenu("_Scene-Save")

	QuadMenu.addSeparator()

	_OpenSceneMenu = QuadMenu.addMenu("_Scene-Open")	separators:#( 2, 3 )

)

function configQuad2 QuadMenu =
(
	QuadMenu.setTitle(" X-R E F")

	QuadMenu.addMenu("_Scene-Xref")	separators:#( 3 )
)

function configQuad3 QuadMenu =
(
	QuadMenu.setTitle("S C E N E  R E S E T")

	QuadMenu.addMenu("_Scene-Reset") separators:#(2)

)

function configQuad4 QuadMenu =
(
	QuadMenu.setTitle("OTHERS")

	QuadMenu.addMenu("_Options")

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Viewports-Screenshot")
)
