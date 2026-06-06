filein( getFilenamePath(getSourceFileName()) + "/../MenuBuildManager/MenuBuildManager.ms" )	--"./../MenuBuildManager/MenuBuildManager.ms"



function runQuadModifierNormalizeProof =
(
	modifier_names_input = #(
		#none,
		#shift,
		#controlPressed,
		#altPressed,
		#Controlandshift,
		#AltandshiftPressed,
		#controlAndAltPressed,
		#shiftAndControlAndAltPressed,
		#shiftAndAltAndControlPressed
	)

	modifier_names_valid = #(
		#nonePressed,
		#shiftPressed,
		#controlPressed,
		#altPressed,
		#shiftAndControlPressed,
		#shiftAndAltPressed,
		#controlAndAltPressed,
		#shiftAndAltAndControlPressed
	)

	for modifier_name in modifier_names_input do
	(
		normalized_mod = MenuBuildManager.normalizeQuadModifier modifier_name
		format "%: input:% normalized_mod:%\n" (findItem modifier_names_valid normalized_mod > 0) modifier_name normalized_mod
	)

	true -- return
)

/*
	Create one test quad for each canonical modifier.
	Use do_install:false for queue-only validation.
*/
function runQuadModifierQueuedQuadTest do_install:false =
(
	MenuBuildManager.clearWaitForBuild()

	modifier_specs = #(
		#("None", "RMB", #nonePressed),
		#("Shift", "Shift+RMB", #shiftPressed),
		#("Ctrl", "Ctrl+RMB", #controlPressed),
		#("Alt", "Alt+RMB", #altPressed),
		#("ShiftCtrl", "Shift+Ctrl+RMB", #shiftAndControlPressed),
		#("ShiftAlt", "Shift+Alt+RMB", #shiftAndAltPressed),
		#("CtrlAlt", "Ctrl+Alt+RMB", #controlAndAltPressed),
		#("ShiftAltCtrl", "Shift+Alt+Ctrl+RMB", #shiftAndAltAndControlPressed)
	)

	for modifier_spec in modifier_specs do
	(
		--quad_new = MenuBuildManager.quad ("_Modifier_Test_" + modifier_spec[1])
		quad_new = MenuBuildManager.menu ("_Modifier_Test_" + modifier_spec[1]) type:#quad
		quad_new.quad_modifier = MenuBuildManager.normalizeQuadModifier modifier_spec[3]

		quad_1 = quad_new.getQuad 1
		quad_1.setTitle ("Modifier Test " + modifier_spec[2])
		quad_1.addItem "_TEST_CATEGORY" "_test_macro" title:("ITEM OF: " + modifier_spec[2])
	)

	format "Queued definitions: %\n" MenuBuildManager.wait_for_build.count

	if do_install then
	(
		MenuBuildManager.installMenusNow update_quads:true load_default_cui_configuration:true
	)

	MenuBuildManager.wait_for_build.count -- return
)

runQuadModifierNormalizeProof()
runQuadModifierQueuedQuadTest do_install:false
