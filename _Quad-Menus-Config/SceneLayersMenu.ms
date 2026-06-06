function configQuad1 QuadMenu =
(
	QuadMenu.setTitle("M O V E")

	QuadMenu.addMenu("_SceneLayers-Select")	title:"&Select"	flat:false

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_SceneLayers-Move")	title:"&Move To"	flat:false
	QuadMenu.addMenu("_SceneLayers-Copy")	title:"&Copy To"	flat:false

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_SceneLayers-Instance")	title:"&Instance To"	flat:false
	QuadMenu.addMenu("_SceneLayers-Reference")	title:"&Reference To"	flat:false
)

function configQuad2 QuadMenu =
(
	QuadMenu.setTitle("M A N A G E" )
	QuadMenu.addMenu("_SceneLayers-Manage")

)

function configQuad3 QuadMenu =
(

	QuadMenu.setTitle("V I S I B I L I T Y")

	QuadMenu.addMenu("_SceneLayers-Visibility")
)

function configQuad4 QuadMenu =
(

)
