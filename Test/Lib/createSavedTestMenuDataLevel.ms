
function createMenuRebuilderGuidString =
(
	guid_class = dotNetClass "System.Guid"
	guid_value = guid_class.NewGuid()

	guid_value.ToString() -- return
)


function generateMockMacroScript macro_category macro_name =
(
	macro_script_text = ""
	macro_script_text += "macroScript " + macro_name + " category:\"" + macro_category + "\"\n"
	macro_script_text += "(\n"
	macro_script_text += "\ton execute do\n"
	macro_script_text += "\t(\n"
	macro_script_text += "\t\tformat \"Executed mock macro: " + macro_category + " / " + macro_name + "\\n\"\n"
	macro_script_text += "\t)\n"
	macro_script_text += ")\n"

	execute macro_script_text

	ok -- return
)


function createTestMacroDictionaryLevel level_index item_count:2 submenu_count:1 nested_level_count:1 macro_counter:#(0) macro_category:"_MENU_REBUILDER_TEST_CATEGORY" minimum_submenu_item_count:1 =
(
	dictionary_value = Dictionary #string
	level_item_count = item_count

	if level_index > 0 and level_item_count < minimum_submenu_item_count then
	(
		level_item_count = minimum_submenu_item_count
	)

	for item_index = 1 to level_item_count do
	(
		macro_counter[1] += 1

		title_string = "Item L" + (level_index as string) + "." + (item_index as string)
		macro_name = "_MENU_REBUILDER_TEST_MACRO_" + (macro_counter[1] as string)

		generateMockMacroScript macro_category macro_name

		dictionary_value[title_string] = #(macro_category, macro_name)
	)

	if level_index < nested_level_count then
	(
		for submenu_index = 1 to submenu_count do
		(
			submenu_title_string = "Submenu L" + (level_index as string) + "." + (submenu_index as string)

			dictionary_value[submenu_title_string] = createTestMacroDictionaryLevel \
				(level_index + 1) \
				item_count:item_count \
				submenu_count:submenu_count \
				nested_level_count:nested_level_count \
				macro_counter:macro_counter \
				macro_category:macro_category \
				minimum_submenu_item_count:minimum_submenu_item_count
		)
	)

	dictionary_value -- return
)


