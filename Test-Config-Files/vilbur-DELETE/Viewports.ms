function configQuad1 QuadMenu =
(
	QuadMenu.setTitle("S W I T C H   V I E W P O R T")

)

function configQuad2 QuadMenu =
(v
	QuadMenu.setTitle("L A Y O U T   L O A D" )

	LayoutsMenu 	= QuadMenu.addMenu("_Viewports-Layout")

	LayoutsMenu.addSeparator()

	for layout in #( #restore_layout_4, #restore_layout_2v, #restore_layout_2h, #restore_layout_3vl, #restore_layout_3ht, #restore_layout_4vl  ) do
		LayoutsMenu.addItem ("_Viewports-Layout-Preset") ( layout as string )

)

function configQuad3 QuadMenu =
(
	QuadMenu.setTitle("M A N A G E   L A Y O U T")

	LayoutsMenu 	= MenuDefinition_v title:("_Viewports-Manage")

	QuadMenu.addMenu( LayoutsMenu )

	QuadMenu.addSeparator()

	QuadMenu.addMenu( "_Viewports-HUD" )

	QuadMenu.addSeparator()

	QuadMenu.addMenu( "_Viewports-Setup" )
)

function configQuad4 QuadMenu =
(
	QuadMenu.setTitle("OPTIONS")

	QuadMenu.addSeparator()

	QuadMenu.addMenu( "_Viewports-Setup-Grid" )
)
