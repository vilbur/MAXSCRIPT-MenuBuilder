/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle("M O D I F I E R S 1")

	ModifiersMenu = MenuDefinition_v title:("_Modifiers-1")


	--ModifiersMenu.addSeparator index: #( 5 )

	--QuadMenu.addSeparator index: #( 2 )
	QuadMenu.addMenu(ModifiersMenu)
)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.setTitle("M O D I F I E R S 2")

	ModifiersMenu = MenuDefinition_v title:("_Modifiers-2")

	--ModifiersMenu.addSeparator index:#( 3, 6 )

	QuadMenu.addMenu(ModifiersMenu)
)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle("M O D I F I E R S 3")

	ModifiersMenu = MenuDefinition_v title:("_Modifiers-3")
	--SplineModsMenu = MenuDefinition_v title:("_Modifiers-Spline")

	QuadMenu.addMenu("_Modifiers-Spline")


	--ModifiersMenu = MenuDefinition_v title:("_Modifiers-2")
	--
	--ModifiersMenu.addSeparator index:#( 3, 6 )

	QuadMenu.addMenu(ModifiersMenu)
)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(
	QuadMenu.setTitle("M O D I F I E R S 4")

	ModifiersMenu = MenuDefinition_v title:("_Modifiers-4")

	--ModifiersMenu.addSeparator index:#( 6, 8 )

	QuadMenu.addMenu(ModifiersMenu)
)



/** DEFIEN QUAD
  */
MenuBuildManager = MenuBuildManager_v()

QuadMenuNew = MenuBuildManager.menu ( getFilenameFile(getSourceFileName()) ) type:#quad
QuadMenuNew.quad_modifier = #shiftAndControlPressed


/** ADD QUAD MENUS
  */
addQuad1( QuadMenuNew.getQuad 1 )
addQuad2( QuadMenuNew.getQuad 2 )
addQuad3( QuadMenuNew.getQuad 3 )
addQuad4( QuadMenuNew.getQuad 4 )

MenuBuildManager.installMenusNow update_quads:true load_default_cui_configuration:true
