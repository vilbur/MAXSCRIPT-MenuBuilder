function configQuad1 QuadMenu =
(
	QuadMenu.setTitle("T E M P A L T E 1")

	QuadMenu.addItem "Edit" "Mirror"	group:"Main UI" title:"Mirror Dialog"
	QuadMenu.addItem "Edit" "Align"	group:"Main UI"

)

function configQuad2 QuadMenu =
(
	QuadMenu.setTitle("M I R R O R")

	QuadMenu.addMenu("_Mirror")
)

function configQuad3 QuadMenu =
(
	QuadMenu.setTitle("T E M P A L T E 3")
)

function configQuad4 QuadMenu =
(
	QuadMenu.setTitle("T E M P A L T E 4")
)
