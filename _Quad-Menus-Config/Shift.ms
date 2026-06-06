function configQuad1 QuadMenu =
(
	QuadMenu.setTitle(" S N A P")

	SnapQuadMenu = MenuBuildManager.quad "Snap"

	QuadMenu.addSeparator()

)

function configQuad2 QuadMenu =
(
	QuadMenu.setTitle("C O O R D S Y S")

	SnapSubmenu = MenuDefinition_v title:("Coordinate System")

	QuadMenu.addMenu(SnapSubmenu)
)

function configQuad3 QuadMenu =
(
	QuadMenu.setTitle("P I V O T")

	QuadMenu.addMenu("_Pivot")	separators: #( 3, 5 )
)

function configQuad4 QuadMenu =
(
	QuadMenu.setTitle("T R A N S F O R M")

	QuadMenu.addMenu("_Transform")	separators: #( 3 )
	QuadMenu.addMenu("_Transform-Lock")	separators: #( 1, 4 )

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Transform-Align")

)
