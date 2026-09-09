
/**
 *
 */
macroscript	edit_poly_insert_vertex
category:	"_Epoly-Edit"
buttonText:	"Insert vertex"
tooltip:	"Insert vertex to selected edges\n\nPress Ctrl|Alt|Shift to add more vertices.\n\nEach pressed mod key adds 1 more vertex (E.G.: Ctrl+Alt+Shift = 4 vertices)"
icon:	"MENU:true|across:3"
(
	--on isVisible	do isEpoly() and isSubObject #( 1, 2 )

	on execute do
	(
		--filein( getFilenamePath(getSourceFileName()) + "/Lib/EpolySelection/EpolySelection.ms" )	-- "./Lib/EpolySelection/EpolySelection.ms"

		modkeys_pressed = for mod_key in #(keyboard.controlPressed, keyboard.altPressed, keyboard.shiftPressed) where mod_key == true collect mod_key

		PolyToolsModeling.InsertVertex (1 + modkeys_pressed.count)
	)
)


/**
 *
 */
macroscript	edit_poly_merge_faces
category:	"_Epoly-Edit"
buttonText:	"Connect To Last vertex"
toolTip:	"Connect To Last vertex"
icon:	"MENU:true"
(
	--on IsVisible return Filters.Is_EPolySpecifyLevel #{2..3}
	--on IsVisible return Filters.Is_EPolySpecifyLevel #{2}

	on execute do
	(
		filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/miauu/miauu_connecttolastselvert.mcr" )

		macros.run "miauu" "miauu_ConnectToLastSelVertAlt"
	)
)


/** CREDIT: miauu
 *
 * https://www.scriptspot.com/3ds-max/scripts/merge-faces
 *
 */
macroscript	edit_poly_merge_faces
category:	"_Epoly-Edit"
buttontext:	"Merge Faces"
toolTip:	"Merge Faces and remove inner edges"
icon:	"MENU:true"
(
	--on isVisible	do isEpoly() and isSubObject #( 1, 2 )

	on execute do
	(
		filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/miauu/merge_faces_v10.ms" )

		macros.run "miauu" "Merge_Faces_v10"
	)

)
