function configQuad1 QuadMenu =
(
	QuadMenu.setTitle("M O D I F I E R S 1")

	ModifiersMenu = MenuDefinition_v title:("_Modifiers-1")

	QuadMenu.addMenu(ModifiersMenu)
)

function configQuad2 QuadMenu =
(
	QuadMenu.setTitle("M O D I F I E R S 2")

	ModifiersMenu = MenuDefinition_v title:("_Modifiers-2")

	QuadMenu.addMenu(ModifiersMenu)
)

function configQuad3 QuadMenu =
(
	QuadMenu.setTitle("M O D I F I E R S 3")

	ModifiersMenu = MenuDefinition_v title:("_Modifiers-3")

	QuadMenu.addMenu("_Modifiers-Spline")

	QuadMenu.addMenu(ModifiersMenu)
)

function configQuad4 QuadMenu =
(
	QuadMenu.setTitle("M O D I F I E R S 4")

	ModifiersMenu = MenuDefinition_v title:("_Modifiers-4")

	QuadMenu.addMenu(ModifiersMenu)
)
