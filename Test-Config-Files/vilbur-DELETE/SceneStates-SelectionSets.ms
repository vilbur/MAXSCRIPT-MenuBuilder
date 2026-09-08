function configQuad1 QuadMenu =
(
	QuadMenu.setTitle("SELECTION SETS")

	QuadMenu.addItem "_Selection-Sets" "selection_sets_select" title:"&SELECT"

)

function configQuad2 QuadMenu =
(
	QuadMenu.setTitle("MANAGE SETS")

	QuadMenu.addMenu("_Selection-Sets")	separators: #(  2, 4, 6 )
)

function configQuad3 QuadMenu =
(
	QuadMenu.setTitle("S C E N E   S T A T E S")

	QuadMenu.addMenu("_Scene-States")

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Scene-States-Parts")

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Scene-States-IO")
)

function configQuad4 QuadMenu =
(

	QuadMenu.setTitle("S C E N E  S T A T E")

	_SceneStatesMenu = QuadMenu.addMenu("_Scene-States-Manage")
)
