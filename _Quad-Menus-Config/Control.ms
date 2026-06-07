function configQuad1 QuadMenu =
(
	--format "\n"; print "Control.ms.configQuad1()"
	--format "QuadMenu: %\n" QuadMenu
	QuadMenu.setTitle("QUAD TITLE 1")

	QuadMenu.addItem("Tools")("Hide Selection")	group:"Main UI" title:"Hide SELECTED"
	QuadMenu.addItem("Tools")("Hide Unselected")	group:"Main UI" title:"Hide UNSELECTED"
	
	QuadMenu.addItem "_TEST_CATEGORY" "_test_macro" --title:("ITEM OF:"+modifier_spec[2])

	QuadMenu.addSeparator()
	
	QuadMenu.addMenu("_Visibility-Hide")
	
	QuadMenu.addSeparator()
	
	QuadMenu.addItem("Tools")("Freeze Selection")	group:"Main UI"
	QuadMenu.addItem("Tools")("Unfreeze All")	group:"Main UI"
	
	QuadMenu.addSeparator()
	
	QuadMenu.addMenu("_Selection-Object")
	
)

function configQuad2 QuadMenu =
(
	QuadMenu.setTitle("QUAD TITLE 2")
	
	QuadMenu.addItem "_TEST_CATEGORY" "_test_macro" --title:("ITEM OF:"+modifier_spec[2])

	QuadMenu.addMenu( "_Selection-Filter" ) separators:#(3)
	
	QuadMenu.addSeparator()
	
	QuadMenu.addMenu("_Selection-Copy")
	
	QuadMenu.addSeparator()
	
	QuadMenu.addMenu("_Selection-Instance")
	
	QuadMenu.addSeparator()
	
	QuadMenu.addMenu("_Selection-Edit")	separators:#(2)

)

function configQuad3 QuadMenu =
(
	QuadMenu.setTitle("QUAD TITLE 3")

	ObjectNameMenu	= MenuDefinition_v title:("_Object-Name")
	
	QuadMenu.addMenu("_Wirecolor")
	
	QuadMenu.addSeparator()
	
	QuadMenu.addMenu(ObjectNameMenu)
)

function configQuad4 QuadMenu =
(
	QuadMenu.setTitle("QUAD TITLE 4")

	QuadMenu.addItem("Tools")("Unhide All")	group:"Main UI" title:"UNHIDE ALL"
	
	QuadMenu.addMenu("_Visibility-Unhide")
	
	QuadMenu.addSeparator()
	
	QuadMenu.addMenu("_Selection-Hierarchy")
)
