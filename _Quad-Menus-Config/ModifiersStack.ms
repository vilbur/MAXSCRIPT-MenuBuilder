function configQuad1 QuadMenu =
(
	QuadMenu.setTitle("M O D - S T A C K  1")

	_ModifiersManage = QuadMenu.addMenu("_Modifiers-Manage") separators: #( 2, 3, 5 )

)

function configQuad2 QuadMenu =
(
	QuadMenu.setTitle("M O D - S T A C K  2")

	QuadMenu.addMenu("_Modifiers-Name")	separators: #( 3, 4 )

)

function configQuad3 QuadMenu =
(
	QuadMenu.setTitle("M O D - S T A C K  3")

	QuadMenu.addMenu("_Modifiers-Remote-Stack")

)

function configQuad4 QuadMenu =
(
	QuadMenu.setTitle("M O D - S T A C K  4")

	QuadMenu.addMenu("_Modifiers-Gizmo")
)
