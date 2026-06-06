macroScript TripleModifierQuadTestBox
category:"_TRIPLE_MODIFIER_QUAD_TEST"
toolTip:"Triple Modifier Quad Test Box"
buttonText:"Triple Modifier Quad Test Box"
(
	on execute do
	(
		box name:"Triple_Modifier_Quad_Test_Box"
	)
)


/*
Create triple modifier quad in CUI callback.
This tests Shift+Alt+Ctrl RMB without menuMan.
*/
function tripleModifierQuadCallback =
(
	quad_menu_manager = callbacks.notificationParam()
	viewport_context_id = "ac7c70f8-3f86-4ff5-a510-e4fd6a9c368e"
	quad_context = undefined
	quad_menu = undefined
	quad_position_menu = undefined
	read_back_quad = undefined

	if quad_menu_manager == undefined then
	(
		format "FAILED: quad_menu_manager is undefined.\n"
	)
	else
	(
		try
		(
			quad_context = quad_menu_manager.GetContextById viewport_context_id
		)
		catch
		(
			quad_context = undefined
		)

		if quad_context == undefined then
		(
			format "FAILED: viewport quad context is undefined.\n"
		)
		else
		(
			try
			(
				quad_menu = quad_context.CreateQuadMenu "79C44895-5A9C-4F47-B9F0-782CA1AD1027" "_TRIPLE_MODIFIER_QUAD_TEST"
			)
			catch
			(
				quad_menu = undefined
			)

			if quad_menu == undefined then
			(
				format "FAILED: CreateQuadMenu returned undefined.\n"
			)
			else
			(
				try
				(
					quad_context.SetRightClickModifiers quad_menu #shiftAndAltAndControlPressed
					format "SetRightClickModifiers OK: #shiftAndAltAndControlPressed\n"
				)
				catch
				(
					format "FAILED: SetRightClickModifiers #shiftAndAltAndControlPressed\n"
				)

				try
				(
					read_back_quad = quad_context.GetRightClickMenuByModifiers #shiftAndAltAndControlPressed
				)
				catch
				(
					read_back_quad = undefined
				)

				if read_back_quad == undefined then
				(
					format "READBACK FAILED: #shiftAndAltAndControlPressed returns undefined.\n"
				)
				else
				(
					format "READ_BACK_QUAD: %\n" read_back_quad
				)

				try
				(
					quad_position_menu = quad_menu.CreateMenu "8E365B3F-7E41-4E3B-A8F4-E2E1F7B71E7C" "Triple Modifier Test" #TopRight
				)
				catch
				(
					quad_position_menu = undefined
				)

				if quad_position_menu == undefined then
				(
					format "FAILED: CreateMenu returned undefined.\n"
				)
				else
				(
					quad_position_menu.CreateAction "05F4A31E-5C43-4F08-9A14-2590C7F56F07" 647394 "TripleModifierQuadTestBox`_TRIPLE_MODIFIER_QUAD_TEST"
					format "ACTION ADDED: TripleModifierQuadTestBox\n"
				)
			)
		)
	)

	ok -- return
)


/*
Install and trigger quad callback.
This reloads quad configuration so callback runs immediately.
*/
function installTripleModifierQuadCallbackTest =
(
	quad_menu_manager = undefined

	callbacks.removeScripts id:#tripleModifierQuadCallbackTest
	callbacks.addScript #cuiRegisterQuadMenus "tripleModifierQuadCallback()" id:#tripleModifierQuadCallbackTest

	try
	(
		quad_menu_manager = maxOps.GetICuiQuadMenuMgr()
	)
	catch
	(
		quad_menu_manager = undefined
	)

	if quad_menu_manager == undefined then
	(
		format "FAILED: maxOps.GetICuiQuadMenuMgr() returned undefined.\n"
	)
	else
	(
		try
		(
			quad_menu_manager.LoadConfiguration (quad_menu_manager.GetDefaultConfiguration())
			format "Quad configuration reloaded. Test Shift+Alt+Ctrl+RMB in viewport.\n"
		)
		catch
		(
			format "FAILED: quad_menu_manager.LoadConfiguration default configuration.\n"
		)
	)

	ok -- return
)


installTripleModifierQuadCallbackTest()