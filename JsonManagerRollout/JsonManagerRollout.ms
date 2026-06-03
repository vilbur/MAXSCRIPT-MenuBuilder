
rollout MenuBuildManagerJsonRollout "Menu JSON Manager" width:470 height:390
(
	local json_manager = undefined
	local menu_title_array = #()
	local menu_signature_array = #()
	local quad_title_array = #()
	local quad_signature_array = #()

	label json_path_label "JSON:" pos:[10,10] width:440 height:16
	editText json_path_text "" pos:[10,28] width:450 height:18 readOnly:true

	groupBox menu_group "Menus from JSON" pos:[10,55] width:220 height:250
	multiListBox menu_multilist "" pos:[20,75] width:200 height:13 items:#()

	groupBox quad_group "Quad Menus from JSON" pos:[240,55] width:220 height:250
	multiListBox quad_multilist "" pos:[250,75] width:200 height:13 items:#()

	button refresh_button "Refresh" pos:[10,315] width:105 height:28
	button delete_selected_button "Delete Selected From JSON" pos:[125,315] width:165 height:28
	button delete_all_button "Delete All From JSON" pos:[300,315] width:160 height:28
	button clear_json_button "Clear JSON File" pos:[10,350] width:450 height:28


	/*  Creates rollout manager instance.
	    Uses default shared JSON file path.
	*/
	function getManager =
	(
		if json_manager == undefined then
		(
			json_manager = MenuBuildManager_v()
		)

		json_manager -- return
	)


	/*  Refreshes multilistboxes from JSON file.
	    Lists normal menus and quad menus separately.
	*/
	function refreshLists =
	(
		manager_value = getManager()
		json_path_text.text = manager_value.data_file_path

		menu_title_array = #()
		menu_signature_array = #()
		quad_title_array = #()
		quad_signature_array = #()

		menus_data_array = manager_value.loadSavedMenusDataFromJson()

		for menu_data in menus_data_array do
		(
			menu_title = manager_value.getSavedMenuTitle menu_data
			menu_type = manager_value.getSavedMenuType menu_data
			menu_signature = manager_value.getMenuDataSignature menu_data

			if menu_title != "" then
			(
				if menu_type == #menu or menu_type == #both then
				(
					append menu_title_array menu_title
					append menu_signature_array menu_signature
				)

				if menu_type == #quad or menu_type == #both then
				(
					append quad_title_array menu_title
					append quad_signature_array menu_signature
				)
			)
		)

		menu_multilist.items = menu_title_array
		menu_multilist.selection = #{}

		quad_multilist.items = quad_title_array
		quad_multilist.selection = #{}

		ok -- return
	)


	/*  Gets selected menu signatures from both multilistboxes.
	    Signatures are used to delete JSON entries.
	*/
	function getSelectedSignatures =
	(
		selected_signatures = #()

		for menu_index in menu_multilist.selection do
		(
			if menu_index > 0 and menu_index <= menu_signature_array.count then
			(
				append selected_signatures menu_signature_array[menu_index]
			)
		)

		for quad_index in quad_multilist.selection do
		(
			if quad_index > 0 and quad_index <= quad_signature_array.count then
			(
				append selected_signatures quad_signature_array[quad_index]
			)
		)

		selected_signatures -- return
	)


	/*  Deletes selected JSON entries.
	    Current already-created UI menus are not removed until CUI rebuild/restart.
	*/
	function deleteSelectedFromJson =
	(
		selected_signatures = this.getSelectedSignatures()

		if selected_signatures.count == 0 then
		(
			messageBox "No menu selected." title:"Menu JSON Manager"
		)
		else
		(
			manager_value = this.getManager()
			manager_value.deleteMenusFromJsonBySignatures selected_signatures
			this.refreshLists()
		)

		ok -- return
	)


	/*  Deletes all JSON entries.
	    JSON file remains valid with empty menus array.
	*/
	function deleteAllFromJson =
	(
		if queryBox "Delete all menu and quad menu entries from JSON file?" title:"Menu JSON Manager" then
		(
			manager_value = this.getManager()
			manager_value.deleteAllMenusFromJson()
			this.refreshLists()
		)

		ok -- return
	)


	on MenuBuildManagerJsonRollout open do
	(
		refreshLists()
	)

	on refresh_button pressed do
	(
		refreshLists()
	)

	on delete_selected_button pressed do
	(
		deleteSelectedFromJson()
	)

	on delete_all_button pressed do
	(
		deleteAllFromJson()
	)

	on clear_json_button pressed do
	(
		deleteAllFromJson()
	)
)


/*  Opens menu JSON manager rollout.
    Lists menus and quad menus stored in shared JSON file.
*/
function openMenuBuildManagerJsonRollout =
(
	try
	(
		destroyDialog MenuBuildManagerJsonRollout
	)
	catch
	(
		ok
	)

	createDialog MenuBuildManagerJsonRollout

	ok -- return
)

