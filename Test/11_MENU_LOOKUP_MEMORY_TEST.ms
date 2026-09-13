/* Run in 3ds Max. Uses a temporary native cache and does not install menus. */
fileIn (getFilenamePath (getSourceFileName()) + "../Lib/MenuBuildManager/MenuBuildManager.ms")

(
	local cache_path = (getDir #temp) + "\\MenuBuilder_lookup_memory_test.msdata"
	local source_data = #()
	for menu_index = 1 to 50 do
	(
		local menu_data = Dictionary #name
		local menu_items = #()
		menu_data[#id] = "menu-" + menu_index as string
		menu_data[#title] = "Saved menu " + menu_index as string
		menu_data[#type] = #menu
		for item_index = 1 to 200 do
		(
			local item_data = Dictionary #name
			item_data[#id] = (menu_index as string) + "-" + item_index as string
			item_data[#title] = "Action " + item_index as string
			item_data[#category] = "Category"
			item_data[#macro] = "Macro " + item_index as string
			append menu_items item_data
		)
		menu_data[#items] = menu_items
		append source_data menu_data
	)

	local writer = MenuBuildManager_v compile_mode:#PRODUCTION native_data_file_path:cache_path auto_register_callback:false
	writer.writeSavedMenusDataToJson source_data

	local manager = MenuBuildManager_v compile_mode:#PRODUCTION native_data_file_path:cache_path auto_register_callback:false
	manager.findSavedMenuDataByTitle "Missing menu 0"
	gc light:true
	local heap_before = heapSize - heapFree
	local started_at = timeStamp()
	for lookup_index = 1 to 1000 do manager.findSavedMenuDataByTitle ("Missing menu " + lookup_index as string)
	gc light:true
	local heap_delta = (heapSize - heapFree) - heap_before

	if not manager.saved_menus_data_loaded then throw "Saved menu cache was not marked as loaded."
	if manager.saved_menus_data.count != source_data.count then throw "Saved menu cache count changed."
	format "Ran 1000 misses against 10000 saved actions in % ms. Heap delta after first load: % bytes.\n" (timeStamp() - started_at) heap_delta
	try (deleteFile cache_path) catch (ok)
)
