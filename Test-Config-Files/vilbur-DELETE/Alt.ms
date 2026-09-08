function configQuad1 QuadMenu =
(
	QuadMenu.setTitle("E D I T 1")

	QuadMenu.addMenu("_Epoly-Options") separators: #( 3 )

)

function configQuad2 QuadMenu =
(
	QuadMenu.setTitle("E D I T 2")

	QuadMenu.addMenu("_Epoly-Hard-Edges")	title:"H A R D - E D G E S" separators: #( 1 )

	QuadMenu.addSeparator()

)

function configQuad3 QuadMenu =
(
	QuadMenu.setTitle("E D I T 3")

	QuadMenu.addMenu("_Epoly-Explode") title:"E X P L O D E" flat:false

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Epoly-Edit-Dialogs")  separators: #( 1, 3 )

)

function configQuad4 QuadMenu =
(
	QuadMenu.setTitle("E D I T 4")

	QuadMenu.addMenu("_Epoly-Selection")

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Epoly-Loop-Tools") separators: #( 1, 2 )

)
