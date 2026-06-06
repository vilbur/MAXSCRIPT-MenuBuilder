
/*------------------------------------------------------------------------------
	LEGACY MENU API COMPATIBILITY HELPERS
--------------------------------------------------------------------------------*/

/*
Get menu item array.
Supports MenuDefinition_v data access.
*/
function getMenuItemArray menu_definition =
(
	item_array = #()

	try
	(
		item_array = menu_definition.getActiveData()
	)
	catch
	(
		item_array = #()
	)

	item_array -- return
)


/*
Check separator item data.
Used by clearMenuSeparators.
*/
function isLegacySeparatorItem item_data =
(
	is_separator = false

	if item_data == #SEPARATOR then
	(
		is_separator = true
	)
	else if classOf item_data == Dictionary then
	(
		try
		(
			if HasDictValue item_data #separator then
			(
				if item_data[#separator] == true then is_separator = true
			)

			if HasDictValue item_data #type then
			(
				if item_data[#type] == #SEPARATOR then is_separator = true
			)

			if HasDictValue item_data #title then
			(
				if item_data[#title] == #SEPARATOR then is_separator = true
			)
		)
		catch
		(
			is_separator = false
		)
	)

	is_separator -- return
)


/*
Get item title from dictionary data.
Returns empty string when title is missing.
*/
function getLegacyItemTitle item_data =
(
	item_title = ""

	if classOf item_data == Dictionary then
	(
		try
		(
			if HasDictValue item_data #title then item_title = item_data[#title] as string
		)
		catch
		(
			item_title = ""
		)
	)

	item_title -- return
)


/*
Find item index by integer, name, string, or title.
*/
function findLegacyMenuItemIndex menu_definition item_key =
(
	item_index_result = 0
	item_array = getMenuItemArray menu_definition

	if classOf item_key == Integer then
	(
		if item_key >= 1 and item_key <= item_array.count then
		(
			item_index_result = item_key
		)
	)
	else
	(
		key_text = item_key as string

		for item_index = 1 to item_array.count do
		(
			if item_index_result == 0 then
			(
				if (getLegacyItemTitle item_array[item_index]) == key_text then
				(
					item_index_result = item_index
				)
			)
		)
	)

	item_index_result -- return
)


/*
Get menu item by index or title.
*/
function getMenuItem menu_definition item_key =
(
	item_data = undefined
	item_array = getMenuItemArray menu_definition
	item_index = findLegacyMenuItemIndex menu_definition item_key

	if item_index > 0 then
	(
		item_data = item_array[item_index]
	)

	item_data -- return
)


/*
Set item title by index or title.
Mirrors title into all known display keys.
*/
function setMenuItemTitle menu_definition item_key item_title =
(
	item_data = getMenuItem menu_definition item_key

	if classOf item_data == Dictionary then
	(
		item_data[#title] = item_title
		item_data[#display_title] = item_title
		item_data[#menu_title] = item_title
		item_data[#buttonText] = item_title
		item_data[#button_text] = item_title
		item_data[#tooltip] = item_title
		item_data[#toolTip] = item_title
		item_data[#label] = item_title
		item_data[#custom_title] = true
	)

	item_data -- return
)


/*
Delete menu item by index, title, array, or bitarray.
*/
function removeMenuItem menu_definition item_key =
(
	item_array = getMenuItemArray menu_definition
	remove_indexes = #()

	if classOf item_key == Integer then
	(
		append remove_indexes item_key
	)
	else if classOf item_key == Array then
	(
		for remove_index in item_key do
		(
			if classOf remove_index == Integer then append remove_indexes remove_index
		)
	)
	else if classOf item_key == BitArray then
	(
		for remove_index in item_key do append remove_indexes remove_index
	)
	else
	(
		found_index = findLegacyMenuItemIndex menu_definition item_key
		if found_index > 0 then append remove_indexes found_index
	)

	remove_indexes = sort remove_indexes

	for remove_index_i = remove_indexes.count to 1 by -1 do
	(
		remove_index = remove_indexes[remove_index_i]

		if remove_index >= 1 and remove_index <= item_array.count then
		(
			deleteItem item_array remove_index
		)
	)

	menu_definition -- return
)


/*
Move menu item by index or title.
*/
function moveMenuItem menu_definition item_key target_index =
(
	item_array = getMenuItemArray menu_definition
	item_index = findLegacyMenuItemIndex menu_definition item_key

	if item_index > 0 then
	(
		item_data = item_array[item_index]
		deleteItem item_array item_index

		if target_index < 1 then target_index = 1
		if target_index > item_array.count + 1 then target_index = item_array.count + 1

		insertItem item_data item_array target_index
	)

	menu_definition -- return
)


/*
Clear separator items from menu definition.
*/
function clearMenuSeparators menu_definition =
(
	item_array = getMenuItemArray menu_definition

	for item_index = item_array.count to 1 by -1 do
	(
		if isLegacySeparatorItem item_array[item_index] then
		(
			deleteItem item_array item_index
		)
	)

	menu_definition -- return
)


/*
Add multiple separators by old API indexes.
*/
function addSeparators menu_definition separator_indexes =
(
	if classOf separator_indexes == Integer then
	(
		menu_definition.addSeparator index:separator_indexes
	)
	else
	(
		for separator_index in separator_indexes do
		(
			menu_definition.addSeparator index:separator_index
		)
	)

	menu_definition -- return
)


/*
Add multiple macro items to menu definition.
*/
function addItems menu_definition macro_category macro_names =
(
	for macro_name in macro_names do
	(
		menu_definition.addItem macro_category (macro_name as string)
	)

	menu_definition -- return
)


/*
Add flat old API menu rows.
Row layout: title, menu_definition, title, menu_definition...
*/
function addMenus target_menu menu_rows separator:false =
(
	row_index = 1

	while row_index <= menu_rows.count do
	(
		if row_index + 1 <= menu_rows.count then
		(
			target_menu.addMenu menu_rows[row_index + 1]

			if separator then
			(
				if row_index + 2 <= menu_rows.count then target_menu.addSeparator()
			)
		)

		row_index += 2
	)

	target_menu -- return
)

/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle("M O V E")

	--FooMenu	= MenuDefinition_v title:("Selection")
	--removeMenuItem FooMenu ()
	--clearMenuSeparators FooMenu


	QuadMenu.addMenu("_SceneLayers-Select")	title:"&Select"	flat:false --separators: #( 1 ) --index:--index:--index:

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_SceneLayers-Move")	title:"&Move To"	flat:false --separators: #( 1 ) --index:--index:--index:
	QuadMenu.addMenu("_SceneLayers-Copy")	title:"&Copy To"	flat:false --separators: #( 1 ) --index:--index:--index:

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_SceneLayers-Instance")	title:"&Instance To"	flat:false --separators: #( 1 ) --index:--index:--index:
	QuadMenu.addMenu("_SceneLayers-Reference")	title:"&Reference To"	flat:false --separators: #( 1 ) --index:--index:--index:
)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.setTitle("M A N A G E" )
	QuadMenu.addMenu("_SceneLayers-Manage")	--title:""	flat:false --separators: #( 1 ) --index:--index:--index:

)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	--QuadMenu.setTitle("I N S T A N C E")
	QuadMenu.setTitle("V I S I B I L I T Y")

	QuadMenu.addMenu("_SceneLayers-Visibility")	--title:""	flat:false --separators: #( 1 ) --index:--index:--index:
)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(

)


/** DEFIEN QUAD
  */
MenuBuildManager = MenuBuildManager_v()

QuadMenuNew = MenuBuildManager.menu ( getFilenameFile(getSourceFileName()) ) type:#quad


/** ADD QUAD MENUS
  */
addQuad1( QuadMenuNew.getQuad 1 )
addQuad2( QuadMenuNew.getQuad 2 )
addQuad3( QuadMenuNew.getQuad 3 )
addQuad4( QuadMenuNew.getQuad 4 )

MenuBuildManager.installMenusNow update_quads:true load_default_cui_configuration:true
