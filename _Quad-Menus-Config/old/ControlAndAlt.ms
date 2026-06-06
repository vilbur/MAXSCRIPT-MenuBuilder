

/** Macroscript for Create HoneycombPlane plugin object
 *
 */
macroscript	HoneycombPlane
category:	"Objects Primitives"
buttontext:	"Honeycomb"
toolTip:	"Create Honeycomb Plane"
--icon:	"Menu:Tooltip"
--icon:	"Tooltip:" --"#(path, index)"
(
	on execute do startObjectCreation HoneycombPlane
)


/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle("A N I M A T I O N")

	--QuadMenu.addMenu("_Animation")	--flat:false --index:1
	--QuadMenu.addMenu(DefaulQuadtMenu.menu)	--flat:false --index:1
	
	QuadMenu.addItem ("_Animation") ("_options_toggle_keyframe_0_1") index:1 title:"Next Frame • CTRL: Last Frame"
	QuadMenu.addItem ("_Animation") ("_options_trackbar_show")
	QuadMenu.addItem ("_Animation") ("_animation_set_animation_range") title:"Set animation range"
	
	
	--QuadMenu.addSeparator index:2
	QuadMenu.addSeparator index:#(2,3)
)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.setTitle(" C R E A T E 2")

	QuadMenu.addMenu("_Create-Shapes")

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Create-Compounds")
)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle(" C R E A T E")
	--
	--standard_primitives_plugin = #(
	--	#hexasphere,
	--	#quadsphere
	--)

	primitives = #(
		#(
			#Plane,
			#Box,
			#Cylinder,
			#Sphere,
			#Teapot,
			#HoneycombPlane

		),
		#(
			#hexasphere,
			#quadsphere,
			#GeoSphere,
			#ChamferBox,
			#Tube,
			#Torus,
			#Cone,
			#Pyramid,
			#TextPlus
		),
		#(
			#C_Ext,
			#Capsule,
			#ChamferCyl,
			#Gengon,
			#Hedra,
			#Hose,
			#L_Ext,
			#OilTank,
			#Prism,
			#Quadpatch,
			#RingWave,
			#Spindle,
			#Torus_Knot,
			#Tripatch
		)
	)


	compound_primitives = #(
		#Loft,
		#Boolean,
		#ProBoolean,
		#Procutter,
		#Conform,
		#Scatter,
		#ShapeMerge
	)

	helpers_primitives = #(
		#point,
		#tape,
		#protractor
	)

	shapes_primitives = #(
		#lines,
		#rectangle,
		#circle,
		#Arc,
		#Text,
		#Ellipse,
		#ShapeMerge
	)

	menus = #(
		/* SUBMENU TITLE */	        /* NAME OF MENU */	             /* CATEGORY O MACROSCRIPTS */	/* MACROSCRIPT`S NAMES */
		"Standard Primitives",	(Menu_v("_Create Standard Primitives")	flat:true ).addItems("Objects Primitives")	(primitives[1]),
		"Shapes",	(Menu_v("_Shapes Primitives")	flat:true).addItems("Objects Shapes")	(shapes_primitives),
		"Helpers",	(Menu_v("_Helpers Primitives")	flat:true).addItems("Objects Helpers")	(helpers_primitives),
		"Other Primitives",	(Menu_v("_Create Other Primitives")	flat:false).addItems("Objects Primitives")	(primitives[2]),
		"Extend Primitives",	(Menu_v("_Create Extended Primitives")	flat:false).addItems("Objects Primitives")	(primitives[3]),
		"Compounds",	(Menu_v("_Compound Primitives")	flat:false).addItems("Objects Compounds")	(compound_primitives)
	)


	--QuadMenu.removeItem #( 1 ) -- Remove Default submenu


	QuadMenu.addMenus(menus) separator:true

	QuadMenu.addItem ("Edit") ("Object Properties") group:"Main UI" index:1

	QuadMenu.addSeparators #( 4 ) -- separator after helpers
)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(
	QuadMenu.setTitle("G R O U P")
	QuadMenu.clearMenu()

	GroupMenu	= Menu_v("_Group")
	GroupMenu.addSeparator index:#( 3, 5, 7 )


	QuadMenu.addMenu(GroupMenu)	--flat:true --index:1
)



/** DEFIEN QUAD
  */
QuadMenuNew = QuadMenu_v( getFilenameFile( getSourceFileName() ) )


/** ADD QUAD MENUS
  */
addQuad1( QuadMenuNew.Quads[1] )
addQuad2( QuadMenuNew.Quads[2] )
addQuad3( QuadMenuNew.Quads[3] )
addQuad4( QuadMenuNew.Quads[4] )