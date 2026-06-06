function configQuad1 QuadMenu =
(
	QuadMenu.setTitle("Edit 1")

	QuadMenu.addMenu("_Epoly-Constraints")

	QuadMenu.addMenu("_Epoly-Tools-Options") separators: #( 1 )

	QuadMenu.addItem ("Editable Spline Object") ("Divide (Spline)")   group:"Main UI"
	QuadMenu.addItem ("Editable Spline Object") ("Connect (Spline)")  group:"Main UI"

	QuadMenu.addMenu("Context Spline Tools 4")

	QuadMenu.addMenu("_Object-ConvertTo") separators: #( 1 )

)

function configQuad2 QuadMenu =
(
	QuadMenu.setTitle("Edit 2")

	QuadMenu.addMenu("_Epoly-Connect") separators: #( 2, 3 )

	QuadMenu.addMenu("_Epoly-Edit")	 separators: #( 1 )

	QuadMenu.addMenu("_Epoly-Edges")	title:"Edges" separators: #( 1 )

	SplineToolsMenu = MenuDefinition_v title:("Context Spline Tools 2")

	QuadMenu.addMenu(SplineToolsMenu)

)

function configQuad3 QuadMenu =
(
	QuadMenu.setTitle("Edit 3")

	QuadMenu.addMenu("_Epoly-Object") separators: #( 1, 3 )

	SplineToolsMenu = MenuDefinition_v title:("Context Spline Tools 3")

	SplineToolsMenu.addItem ("Editable Spline Object") ("Weld Vertices (Spline)")  group:"Main UI"
	SplineToolsMenu.addItem ("Editable Spline Object") ("Fuse Vertices (Spline)")  group:"Main UI"
	SplineToolsMenu.addItem ("Editable Spline Object") ("Break Vertices (Spline)") group:"Main UI"

	QuadMenu.addMenu(SplineToolsMenu)

)

function configQuad4 QuadMenu =
(
	QuadMenu.setTitle("EDIT 4")

	QuadMenu.addMenu("_Epoly-Tools-Main") separators: #( 2, 6 )

	QuadMenu.addMenu("_Epoly-PolyTools") separators: #( 1 )

	SplineToolsMenu = QuadMenu.addMenu("Context Spline Tools 1")

)
