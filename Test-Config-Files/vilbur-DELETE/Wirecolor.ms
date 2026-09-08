function configQuad1 QuadMenu =
(
	QuadMenu.setTitle("C O L O R")

	QuadMenu.addMenu("Vertex-Color-Manage-Set")

	QuadMenu.addSeparator()

	QuadMenu.addMenu("Vertex-Color-Set")

	QuadMenu.addSeparator()

	QuadMenu.addMenu("Vertex-Color-Manage")

	QuadMenu.addMenu("_Wirecolor")

)

function configQuad2 QuadMenu =
(
	QuadMenu.setTitle("T E M P A L T E 2")
)

function configQuad3 QuadMenu =
(
	QuadMenu.setTitle("T E M P A L T E 3")

)

function configQuad4 QuadMenu =
(
	QuadMenu.setTitle("T E M P A L T E 4")

	QuadMenu.addItem ("Vertex-Color-Manage") ("epoly_vertex_color_property_toggle")

)
