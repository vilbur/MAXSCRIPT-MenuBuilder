clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../MenuBuildManager/MenuBuildManager.ms" )	--"./../MenuBuildManager/MenuBuildManager.ms"

filein( getFilenamePath(getSourceFileName()) + "/_INCLUDE-TEST_MACROSCRIPT.mcr" )	--"./_INCLUDE-TEST_MACROSCRIPT.mcr"


native_quad_names =
#(
	"Default Viewport Quad",
	"Snap",
	"Animation",
	"Modeling",
	"MassFX",
	"User Defined 1",
	"Lighting | Render",
	"User Defined 2",

	"Track View Key Quad (Classic)",
	"Trackbar Quad",
	"Viewports",
	"Track View Key Quad",



	"LayerExplorer Quad",
	"SceneExplorer Quad",
	"Lock",
	"Windows",
	"Texture Tools",

	"ActiveShade Quad",
	"Unwrap UVW Quad",
	"Schematic View Quad",
	"Track View Quad",
	"Asset Tracking Quad",
	"Retimer Span Type"
)

/* IMPORTANT: INJECTING WORKS ONLY IN FOLLOWING MENUS
  
	'Default Viewport Quad'
	'Snap                     Shift+RMB'
	'Animation                Alt+RMB'
	'Modeling                 Ctrl+RMB'
	'MassFX                   Shift+Alt+RMB'
	'User Defined 1         Shift+Ctrl+RMB'
	'Lighting | Render        Ctrl+Alt+RMB'
*/ 

MenuBuildManager = MenuBuildManager_v()

for quad_name in native_quad_names do
(
	quad_default = MenuBuildManager.getQuad quad_name clear_default_menu:true
	quad_1 = quad_default.getQuad 1
	quad_1.addItem "_TEST_CATEGORY" "_test_macro" title:("ITEM OF:"+quad_name)
)

MenuBuildManager.installMenusNow update_quads:true load_default_cui_configuration:true
