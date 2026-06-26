function configQuad1 QuadMenu =
(
	QuadMenu.setTitle("A N I M A T I O N")

	QuadMenu.addItem ("_Animation") ("_options_toggle_keyframe_0_1") index:1 title:"Next Frame • CTRL: Last Frame"
	QuadMenu.addItem ("_Animation") ("_options_trackbar_show")
	QuadMenu.addItem ("_Animation") ("_animation_set_animation_range") title:"Set animation range"

	--QuadMenu.addSeparator index:#(2,3)
)

function configQuad2 QuadMenu =
(
	QuadMenu.setTitle(" C R E A T E 2")

	QuadMenu.addMenu("_Create-Shapes")

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Create-Compounds")
)

function configQuad3 QuadMenu =
(
	QuadMenu.setTitle(" C R E A T E")

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
         /* SUBMENU TITLE */     /* NAME OF MENU */                     /* CATEGORY OF MACROSCRIPTS */	/* MACROSCRIPT`S NAMES */
		 
         "Standard Primitives", (Menu_v("_Create Standard Primitives") flat:true).addItems("Objects Primitives")		(primitives[1]),
         "Shapes",              (Menu_v("_Shapes Primitives")          flat:true).addItems("Objects Shapes")		(shapes_primitives),
         "Helpers",             (Menu_v("_Helpers Primitives")         flat:true).addItems("Objects Helpers")		(helpers_primitives),
         "Other Primitives",    (Menu_v("_Create Other Primitives")    flat:false).addItems("Objects Primitives")	(primitives[2]),
         "Extend Primitives",   (Menu_v("_Create Extended Primitives") flat:false).addItems("Objects Primitives")	(primitives[3]),
         "Compounds",           (Menu_v("_Compound Primitives")        flat:false).addItems("Objects Compounds")		(compound_primitives)
	)


	--QuadMenu.removeItem #( 1 ) -- Remove Default submenu


	QuadMenu.addMenus(menus) separator:true


	QuadMenu.addItem ("Edit") ("Object Properties") group:"Main UI" index:1

)

function configQuad4 QuadMenu =
(
	QuadMenu.setTitle("G R O U P")

    GroupMenu	= MenuDefinition_v title:("_Group")
	
	--GroupMenu.addSeparator index:#( 3, 5, 7 )

	QuadMenu.addMenu(GroupMenu)
)
