/* 
MenuRebuilder Action Binding System 0.10
Fixes macro-script binding issues and unsafe menu actions
*/

global function resolveMenuAction
(
    category_name,
    macro_name
)
(
    action_item = undefined

    if category_name != undefined and macro_name != undefined then
    (
        action_item = actionMan.findAction macro_name

        if action_item == undefined then
        (
            /* fallback: try category scan */
            action_count = actionMan.getNumActions()

            for i = 1 to action_count do
            (
                a = actionMan.getAction i

                if a != undefined then
                (
                    if a.category == category_name then
                    (
                        if a.name == macro_name then
                        (
                            action_item = a
                        )
                    )
                )
            )
        )
    )

    -- return
    action_item
)

global function safeAddMenuItem
(
    menu_obj,
    category_name,
    macro_name,
    fallback_label
)
(
    action_item = resolveMenuAction category_name macro_name

    if action_item != undefined then
    (
        menu_obj.addItem action_item
    )
    else
    (
        format "Missing action: % in category %\n" macro_name category_name

        if fallback_label != undefined then
        (
            menu_obj.addStringItem fallback_label
        )
    )

    -- return
    true
)

global function rebuildMenusFromJson
(
    json_data
)
(
    menu_count = json_data.count

    for i = 1 to menu_count do
    (
        menu_def = json_data[i]

        menu_obj = menu_def.menu

        item_count = menu_def.items.count

        for j = 1 to item_count do
        (
            item = menu_def.items[j]

            if item.type == "macro" then
            (
                safeAddMenuItem menu_obj item.category item.macro item.label
            )
            else if item.type == "separator" then
            (
                menu_obj.addSeparator()
            )
            else
            (
                menu_obj.addStringItem item.label
            )
        )
    )

    -- return
    true
)

/* TEST */

global function testBindingSystem
(
)
(
    test_action = resolveMenuAction "_MenuRebuilder" "_test_macro"

    format "Test action found: %\n" test_action

    -- return
    true
)

testBindingSystem()
