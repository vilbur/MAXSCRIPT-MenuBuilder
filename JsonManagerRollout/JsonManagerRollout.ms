rollout MenuBuildManagerJsonRollout "Menu JSON Manager" width:560 height:430
(
	local json_manager = undefined
	local menu_title_array = #()
	local menu_signature_array = #()
	local quad_title_array = #()
	local quad_signature_array = #()

	label json_path_label "JSON location:" pos:[10,10] width:540 height:16
	editText json_path_text "" pos:[10,28] width:540 height:18 readOnly:true

	label json_status_label "" pos:[10,50] width:540 height:16

	groupBox menu_group "Menus from JSON" pos:[10,75] width:265 height:265
	multiListBox menu_multilist "" pos:[20,95] width:245 height:15 items:#()

	groupBox quad_group "Quad Menus from JSON" pos:[285,75] width:265 height:265
	multiListBox quad_multilist "" pos:[295,95] width:245 height:15 items:#()

	button refresh_button "Refresh" pos:[10,350] width:120 height:28
	button delete_selected_button "Delete Selected From JSON" pos:[140,350] width:210 height:28
	button delete_all_button "Delete All From JSON" pos:[360,350] width:190 height:28
	button clear_json_button "Clear JSON Data" pos:[10,390] width:540 height:28


	/* Get manager instance.
	   Rollout reuses one manager instance.
	*/
	function getManager =
	(
		if json_manager == undefined then
		(
			json_manager = MenuBuildManager_v()
		)

		json_manager -- return
	)


	/* Check value for Dictionary class.
	   Used before dictionary key access.
	*/
	function isDictionaryValue value =
	(
		was_dictionary = false

		if value != undefined then
		(
			if classOf value == Dictionary then
			(
				was_dictionary = true
			)
		)

		was_dictionary -- return
	)


	/* Safely check dictionary key.
	   Works with Dictionary #name and #string without crashing rollout.
	*/
	function hasDictValueSafe dictionary_value dictionary_key =
	(
		was_found = false

		if isDictionaryValue dictionary_value then
		(
			try
			(
				was_found = HasDictValue dictionary_value dictionary_key
			)
			catch
			(
				was_found = false
			)
		)

		was_found -- return
	)


	/* Get string property from manager.
	   Used because older manager versions do not have split properties.
	*/
	function getManagerStringProperty manager_value property_name default_value =
	(
		property_value = default_value

		try
		(
			property_value = getProperty manager_value property_name
		)
		catch
		(
			property_value = default_value
		)

		if property_value == undefined then
		(
			property_value = default_value
		)

		property_value -- return
	)


	/* Get bool property from manager.
	   Used to detect split JSON mode.
	*/
	function getManagerBoolProperty manager_value property_name default_value =
	(
		property_value = default_value

		try
		(
			property_value = getProperty manager_value property_name
		)
		catch
		(
			property_value = default_value
		)

		if property_value == undefined then
		(
			property_value = default_value
		)

		property_value -- return
	)


	/* Get JSON location label text.
	   Split mode shows data directory instead of old single file path.
	*/
	function getJsonLocationText manager_value =
	(
		location_text = manager_value.data_file_path
		split_enabled = getManagerBoolProperty manager_value #split_json_enabled false

		if split_enabled then
		(
			try
			(
				location_text = manager_value.getSplitDataRootDirectory()
			)
			catch
			(
				location_text = manager_value.data_file_path
			)
		)

		location_text -- return
	)


	/* Get saved menu title safely.
	   Uses manager method when available.
	*/
	function getSavedMenuTitleSafe manager_value menu_data =
	(
		menu_title = ""

		try
		(
			menu_title = manager_value.getSavedMenuTitle menu_data
		)
		catch
		(
			if hasDictValueSafe menu_data #title then
			(
				menu_title = menu_data[#title]
			)
		)

		menu_title -- return
	)


	/* Get saved menu type safely.
	   Uses manager method when available.
	*/
	function getSavedMenuTypeSafe manager_value menu_data =
	(
		menu_type = #menu

		try
		(
			menu_type = manager_value.getSavedMenuType menu_data
		)
		catch
		(
			if hasDictValueSafe menu_data #type then
			(
				menu_type = menu_data[#type]
			)
		)

		menu_type -- return
	)


	/* Build menu signature safely.
	   Signature format matches MenuBuildManager_v.getMenuDataSignature().
	*/
	function getMenuDataSignatureSafe manager_value menu_data =
	(
		signature = ""

		try
		(
			signature = manager_value.getMenuDataSignature menu_data
		)
		catch
		(
			menu_title = getSavedMenuTitleSafe manager_value menu_data
			menu_type = getSavedMenuTypeSafe manager_value menu_data

			if menu_title != "" then
			(
				signature = (menu_type as string) + "|" + menu_title
			)
		)

		signature -- return
	)


	/* Get custom menu root title.
	   Current version uses _Custom-Menus.
	*/
	function getCustomMenuRootTitle manager_value =
	(
		getManagerStringProperty manager_value #custom_menu_root_title "_Custom-Menus" -- return
	)


	/* Test if menu data is runtime custom root.
	   Root is displayed flattened, not as one menu entry.
	*/
	function isCustomMenuRootData manager_value menu_data =
	(
		was_found = false
		menu_title = getSavedMenuTitleSafe manager_value menu_data
		menu_type = getSavedMenuTypeSafe manager_value menu_data
		custom_root_title = getCustomMenuRootTitle manager_value

		if menu_type == #menu then
		(
			if menu_title == custom_root_title then
			(
				was_found = true
			)
		)

		was_found -- return
	)


	/* Create pseudo menu data from child under _Custom-Menus.
	   Used only for display and signature matching.
	*/
	function createChildMenuData child_key child_data =
	(
		child_menu_data = Dictionary #name
		child_title = ""
		child_items = Dictionary #string

		if hasDictValueSafe child_data #title then
		(
			child_title = child_data[#title]
		)

		if hasDictValueSafe child_data #items then
		(
			child_items = child_data[#items]
		)

		child_menu_data[#id] = child_key
		child_menu_data[#title] = child_title
		child_menu_data[#type] = #menu
		child_menu_data[#items] = child_items

		child_menu_data -- return
	)


	/* Append menu entry to rollout arrays.
	   Keeps title and signature arrays aligned.
	*/
	function appendMenuEntry manager_value menu_data =
	(
		menu_title = getSavedMenuTitleSafe manager_value menu_data
		menu_signature = getMenuDataSignatureSafe manager_value menu_data

		if menu_title != "" then
		(
			append menu_title_array menu_title
			append menu_signature_array menu_signature
		)

		ok -- return
	)


	/* Append quad entry to rollout arrays.
	   Keeps title and signature arrays aligned.
	*/
	function appendQuadEntry manager_value menu_data =
	(
		menu_title = getSavedMenuTitleSafe manager_value menu_data
		menu_signature = getMenuDataSignatureSafe manager_value menu_data

		if menu_title != "" then
		(
			append quad_title_array menu_title
			append quad_signature_array menu_signature
		)

		ok -- return
	)


	/* Append custom root children as normal menu entries.
	   Current split system saves each child as separate file.
	*/
	function appendCustomRootChildren manager_value custom_root_data =
	(
		if hasDictValueSafe custom_root_data #items then
		(
			custom_items = custom_root_data[#items]
			custom_item_keys = GetDictKeys custom_items

			for custom_item_key in custom_item_keys do
			(
				child_data = custom_items[custom_item_key]
				child_menu_data = createChildMenuData custom_item_key child_data
				appendMenuEntry manager_value child_menu_data
			)
		)

		ok -- return
	)


	/* Refresh list boxes from current JSON system.
	   Works with split JSON and old single JSON fallback.
	*/
	function refreshLists =
	(
		manager_value = getManager()
		json_path_text.text = getJsonLocationText manager_value

		menu_title_array = #()
		menu_signature_array = #()
		quad_title_array = #()
		quad_signature_array = #()

		menus_data_array = manager_value.loadSavedMenusDataFromJson()

		for menu_data in menus_data_array do
		(
			menu_type = getSavedMenuTypeSafe manager_value menu_data

			if isCustomMenuRootData manager_value menu_data then
			(
				appendCustomRootChildren manager_value menu_data
			)
			else
			(
				if menu_type == #menu or menu_type == #both then
				(
					appendMenuEntry manager_value menu_data
				)

				if menu_type == #quad or menu_type == #both then
				(
					appendQuadEntry manager_value menu_data
				)
			)
		)

		menu_multilist.items = menu_title_array
		menu_multilist.selection = #{}

		quad_multilist.items = quad_title_array
		quad_multilist.selection = #{}

		json_status_label.text = ((menu_title_array.count as string) + " menus, " + (quad_title_array.count as string) + " quads")

		ok -- return
	)


	/* Get selected menu signatures from both list boxes.
	   Duplicates are allowed but harmless.
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


	/* Check if string exists in array.
	   Used by delete filtering.
	*/
	function isStringInArray string_array string_value =
	(
		was_found = false

		for item_string in string_array while not was_found do
		(
			if item_string == string_value then
			(
				was_found = true
			)
		)

		was_found -- return
	)


	/* Remove selected children from _Custom-Menus root.
	   Empty custom root is removed from saved data.
	*/
	function filterCustomRootChildren manager_value custom_root_data selected_signatures =
	(
		filtered_root = custom_root_data

		if hasDictValueSafe filtered_root #items then
		(
			filtered_items = Dictionary #string
			custom_items = filtered_root[#items]
			custom_item_keys = GetDictKeys custom_items

			for custom_item_key in custom_item_keys do
			(
				child_data = custom_items[custom_item_key]
				child_menu_data = createChildMenuData custom_item_key child_data
				child_signature = getMenuDataSignatureSafe manager_value child_menu_data

				if not isStringInArray selected_signatures child_signature then
				(
					filtered_items[custom_item_key] = child_data
				)
			)

			filtered_root[#items] = filtered_items
		)

		filtered_root -- return
	)


	/* Test if custom root still contains children.
	   Prevents empty _Custom-Menus JSON/runtime root.
	*/
	function customRootHasChildren custom_root_data =
	(
		has_children = false

		if hasDictValueSafe custom_root_data #items then
		(
			item_keys = GetDictKeys custom_root_data[#items]

			if item_keys.count > 0 then
			(
				has_children = true
			)
		)

		has_children -- return
	)


	/* Delete selected signatures from loaded menu data.
	   Save uses current manager write method, so split files are refreshed.
	*/
	function deleteSignaturesFromJson selected_signatures =
	(
		manager_value = getManager()
		menus_data_array = manager_value.loadSavedMenusDataFromJson()
		filtered_menus_data = #()

		for menu_data in menus_data_array do
		(
			if isCustomMenuRootData manager_value menu_data then
			(
				filtered_root = filterCustomRootChildren manager_value menu_data selected_signatures

				if customRootHasChildren filtered_root then
				(
					append filtered_menus_data filtered_root
				)
			)
			else
			(
				menu_signature = getMenuDataSignatureSafe manager_value menu_data

				if not isStringInArray selected_signatures menu_signature then
				(
					append filtered_menus_data menu_data
				)
			)
		)

		manager_value.saved_menus_data = filtered_menus_data
		manager_value.writeSavedMenusDataToJson filtered_menus_data

		try
		(
			manager_value.saveStartupScript()
		)
		catch
		(
			ok
		)

		filtered_menus_data -- return
	)


	/* Delete selected menu and quad JSON entries.
	   Works for split JSON and legacy single JSON.
	*/
	function deleteSelectedFromJson =
	(
		selected_signatures = getSelectedSignatures()

		if selected_signatures.count == 0 then
		(
			messageBox "No menu selected." title:"Menu JSON Manager"
		)
		else
		(
			deleteSignaturesFromJson selected_signatures
			refreshLists()
		)

		ok -- return
	)


	/* Delete all JSON data.
	   Uses manager writer, so split folders are cleared correctly.
	*/
	function deleteAllFromJson =
	(
		if queryBox "Delete all menu and quad menu entries from JSON data?" title:"Menu JSON Manager" then
		(
			manager_value = getManager()
			manager_value.saved_menus_data = #()
			manager_value.writeSavedMenusDataToJson #()

			try
			(
				manager_value.saveStartupScript()
			)
			catch
			(
				ok
			)

			refreshLists()
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


/* Open menu JSON manager rollout.
   Recreates dialog if already open.
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
