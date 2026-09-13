/* Run in 3ds Max. Definitions only: does not install menus or change saved data. */
fileIn (getFilenamePath (getSourceFileName()) + "../Lib/MenuDefinition/MenuDefinition.ms")

(
    local menu_definition = MenuDefinition_v title:"Import regression" data:#()
    local original = menu_definition.addItem "Category" "Macro" title:"Original"
    local original_id = original[#id]
    menu_definition.addSeparator()
    menu_definition.addItem "Category" "Grouped" title:"Grouped" group:"Native"

    local rows = #(
        #("Category", "Macro", "Original"),
        #("Category", "New", ""),
        #("Category", "New", "New"),
        #("Category", "Grouped", "Grouped"),
        #("Category", "Macro", "Alias"),
        #("Category", "macro", "Original"),
        #("a:b", "c", "d"),
        #("a", "b:c", "d")
    )
    local reference = MenuDefinition_v title:"Reference" data:(menu_definition.cloneArrayValue (menu_definition.getActiveData()))
    for row in rows do reference.addItem row[1] row[2] title:row[3]
    menu_definition.addParsedItems rows
    local actual_items = menu_definition.getActiveData()
    local expected_items = reference.getActiveData()
    if actual_items.count != expected_items.count then throw "Import item count differs from addItem."
    for item_index = 1 to actual_items.count do
    (
        for field in #(#category, #macro, #title, #group, #custom_title, #separator) do
            if actual_items[item_index][field] != expected_items[item_index][field] then throw "Import contents/order differ from addItem."
    )
    if actual_items[1][#id] != original_id then throw "Existing ID changed."
    local saved_ids = for item in actual_items collect item[#id]
    menu_definition.addParsedItems rows
    if actual_items.count != saved_ids.count then throw "Repeated import added duplicates."
    for item_index = 1 to actual_items.count do
        if actual_items[item_index][#id] != saved_ids[item_index] then throw "Repeated import changed IDs."
    if menu_definition.last_added_item[#id] != actual_items[actual_items.count][#id] then throw "Last-item anchor changed."

    menu_definition.clearItems()
    menu_definition.addParsedItems rows
    if (menu_definition.getActiveData()).count != rows.count - 1 then throw "Index survived clearItems."
    format "Parsed import regression checks passed.\n"

    -- Increase this count to match a large production menu after the checks pass.
    local stress_count = 10000
    local stress_rows = for item_index = 1 to stress_count collect #("Stress", "Macro" + (item_index as string), "")
    local stress_menu = MenuDefinition_v title:"Import stress" data:#()
    local started_at = timeStamp()
    local heap_before = heapSize - heapFree
    stress_menu.addParsedItems stress_rows
    stress_menu.addParsedItems stress_rows
    if (stress_menu.getActiveData()).count != stress_count then throw "Stress import duplicated items."
    format "Imported % unique items twice in % ms. MAXScript heap delta: % bytes (not total process RAM).\n" stress_count (timeStamp() - started_at) ((heapSize - heapFree) - heap_before)
)
