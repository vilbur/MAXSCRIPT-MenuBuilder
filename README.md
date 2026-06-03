# MAXSCRIPT-MenuBuilder — Front-End Overview

## Purpose

`MenuRebuilder.ms` is a MaxScript framework for building, saving, managing, and rebuilding custom **3ds Max menu-bar menus** and **quad menus**.

It is designed for 3ds Max 2025+ workflows where custom menus should be rebuilt on every 3ds Max launch.

The script allows multiple independent tools to add their own menu data into one shared JSON file. On startup, all saved menu definitions are loaded from JSON and rebuilt automatically.

---

## Main Idea

Each tool creates its own `MenuDefinition_v`.

Then the tool passes this definition to `MenuBuildManager_v`.

`MenuBuildManager_v` converts the definition to saved data and merges it into the shared JSON file.

On 3ds Max startup, all saved data is loaded and rebuilt.

    Tool A creates menu data
    Tool B creates menu data
    Tool C creates quad menu data
            ↓
    MenuBuildManager_v merges all into JSON
            ↓
    3ds Max startup loads JSON
            ↓
    All menus and quad menus are rebuilt

---

## Main User-Facing Features

## 1. Build Normal Menu-Bar Menus

A tool can define a normal menu with menu items and submenus.

Example structure:

    Main Menu Bar
    └── My Tool Menu
        ├── Menu Item 1
        ├── Menu Item 2
        └── Submenu
            └── Submenu Item

Example usage:

    menu_definition = MenuDefinition_v type:#menu title:"My Tool Menu"

    menu_definition.addItem "My Category" "My_Macro_01" title:"Run Tool"

    submenu_definition = menu_definition.addMenu "Utilities"
    submenu_definition.addItem "My Category" "My_Macro_02" title:"Helper Action"

    menu_manager = MenuBuildManager_v menus_data:#(menu_definition)
    menu_manager.run()

---

## 2. Build Quad Menus

A tool can define a quad menu with one or more quadrants.

Example structure:

    Right Click Quad Menu
    ├── Top Right
    │   └── Tool Action
    ├── Top Left
    │   └── Tool Action
    ├── Bottom Left
    │   └── Tool Action
    └── Bottom Right
        └── Tool Action

Example usage:

    quad_definition = MenuDefinition_v type:#quad title:"My Tool Quad"
    quad_definition.data = #()

    quad_top_right = quad_definition.addQuad "Top Right" position:#TopRight
    quad_top_right.addItem "My Category" "My_Macro_01" title:"Quad Action"

    quad_bottom_left = quad_definition.addQuad "Bottom Left" position:#BottomLeft
    quad_bottom_left.addItem "My Category" "My_Macro_02" title:"Another Action"

    menu_manager = MenuBuildManager_v menus_data:#(quad_definition)
    menu_manager.run()

---

## 3. Build Menu and Quad Together

A tool can register both a normal menu and a quad menu in one call.

    menu_definition = MenuDefinition_v type:#menu title:"My Menu"
    menu_definition.addItem "My Category" "My_Macro_01" title:"Menu Action"

    quad_definition = MenuDefinition_v type:#quad title:"My Quad"
    quad_definition.data = #()

    quad_top_right = quad_definition.addQuad "Top Right" position:#TopRight
    quad_top_right.addItem "My Category" "My_Macro_02" title:"Quad Action"

    menu_manager = MenuBuildManager_v menus_data:#(menu_definition, quad_definition)
    menu_manager.run()

---

## 4. Multiple Tools Can Add Menus Independently

Each tool can call `MenuBuildManager_v` separately.

The manager merges new menu data into the shared JSON file instead of overwriting old data.

Example:

    Tool A adds menu
    Tool B adds menu
    Tool C adds quad menu

All entries stay in the same JSON file and are rebuilt on startup.

Example workflow:

    first_menu_definition = MenuDefinition_v type:#menu title:"Tool A Menu"
    first_menu_definition.addItem "Tool A Category" "Tool_A_Action" title:"Run Tool A"

    first_manager = MenuBuildManager_v menus_data:#(first_menu_definition)
    first_manager.run()


    second_menu_definition = MenuDefinition_v type:#menu title:"Tool B Menu"
    second_menu_definition.addItem "Tool B Category" "Tool_B_Action" title:"Run Tool B"

    second_manager = MenuBuildManager_v menus_data:#(second_menu_definition)
    second_manager.run()

After both runs, JSON contains both menus.

---

## Shared JSON File

All menu definitions are saved into:

    MenuRebuilder_data.json

The JSON stores:

- menu title
- menu type
- generated menu ID
- generated menu item IDs
- macro category
- macro name
- submenu structure
- quad context ID
- quad modifier
- quad position
- quad quadrant data

The JSON file is the persistent source of truth.

---

## Startup Loader

The script creates a startup loader file:

    MenuRebuilder_startup.ms

On 3ds Max startup this file:

1. loads `MenuRebuilder.ms`
2. loads `MenuRebuilder_data.json`
3. creates `MenuBuildManager_v`
4. registers CUI callbacks
5. rebuilds all saved menus and quad menus

---

## JSON Manager Rollout

The script includes a UI rollout for managing the JSON file.

Open it with:

    openMenuBuildManagerJsonRollout()

The rollout shows:

- normal menus from JSON
- quad menus from JSON
- current JSON file path

The rollout has buttons:

    Refresh
    Delete Selected From JSON
    Delete All From JSON
    Clear JSON File

Deleting entries from JSON controls what will be rebuilt on the next startup or CUI rebuild.

It does not directly remove already-created visible CUI menu instances in the current session.

---

## Important Rules

## 1. Menu Title Is Required

This is valid:

    MenuDefinition_v type:#menu title:"My Menu"

This is invalid and skipped:

    MenuDefinition_v type:#menu

No fallback title is used.

No hidden `_TEST_MENU` is created.

No title means no menu.

---

## 2. Quad Menus Are Not Created in Normal Menus

Normal menus are rebuilt only from:

    #cuiRegisterMenus

Quad menus are rebuilt only from:

    #cuiRegisterQuadMenus

This prevents quad menu data from being created inside the normal menu bar.

---

## 3. `MenuRebuilder_v` Does Not Decide Menu Type

`MenuRebuilder_v` is only a rebuild worker.

It does not own:

    menu_type
    menu_title
    quad_modifier
    quad_position
    quad_menu_id
    callback_id
    quad_callback_id

Those values are stored in saved `menu_data`.

Routing is handled by `MenuBuildManager_v`.

---

## Main Structs

## MenuDefinition_v

`MenuDefinition_v` is the front-end object used by tools.

It defines:

- menu type
- menu title
- menu data
- menu items
- submenus
- quad quadrants

Public methods:

    addItem category macro_name title:""
    addMenu title
    addQuad title position:#TopRight

Example:

    menu_definition = MenuDefinition_v type:#menu title:"My Menu"
    menu_definition.addItem "Category" "Macro_Name" title:"Visible Item Title"

---

## MenuBuildManager_v

`MenuBuildManager_v` is the main front-end manager.

It is responsible for:

- converting `MenuDefinition_v` into saved menu data
- generating stable menu/item IDs
- merging new menu data into existing JSON
- saving JSON
- saving startup loader
- registering callbacks
- clearing JSON
- deleting selected JSON entries
- loading saved JSON data

Main methods:

    run()
    buildSavedMenusData()
    loadSavedMenusDataFromJson()
    clearJsonFile()
    deleteAllMenusFromJson()
    deleteMenusFromJsonBySignatures signatures
    registerCallback()
    unregisterCallback()

Main usage:

    menu_manager = MenuBuildManager_v menus_data:#(menu_definition)
    menu_manager.run()

---

## MenuRebuilder_v

`MenuRebuilder_v` is an internal rebuild worker.

It receives saved `menu_data` and rebuilds it into the correct CUI manager.

Main methods:

    rebuildAsMainMenu menu_manager
    rebuildAsQuadMenu quad_menu_manager

It should not be used by normal tools directly.

---

## MenuJsonIO_v

`MenuJsonIO_v` handles JSON reading and writing.

It is responsible for:

- converting saved menu data to JSON
- loading menu data from JSON
- parsing JSON into MaxScript dictionaries
- preserving saved GUIDs
- loading multiple menu definitions from one JSON file

Main methods:

    saveMenusDataToJsonFile menus_data_array json_file_path
    loadMenusDataFromJsonFile json_file_path
    menuDataToJson menu_data
    menusDataToJson menus_data_array

---

## Data Flow

    MenuDefinition_v
            ↓
    MenuBuildManager_v.buildSavedMenusData()
            ↓
    saved_menus_data
            ↓
    MenuBuildManager_v.saveJsonData()
            ↓
    MenuRebuilder_data.json
            ↓
    MenuRebuilder_startup.ms
            ↓
    3ds Max startup
            ↓
    MenuBuildManager_v.registerCallback()
            ↓
    #cuiRegisterMenus / #cuiRegisterQuadMenus
            ↓
    MenuRebuilder_v
            ↓
    visible menus and quad menus

---

## Normal Menu Example

    menu_definition = MenuDefinition_v type:#menu title:"My Tool Menu"

    menu_definition.addItem "My Category" "My_Macro_01" title:"Run Main Tool"
    menu_definition.addItem "My Category" "My_Macro_02" title:"Open Settings"

    submenu_definition = menu_definition.addMenu "Utilities"
    submenu_definition.addItem "My Category" "My_Macro_03" title:"Utility Action"

    menu_manager = MenuBuildManager_v menus_data:#(menu_definition)
    saved_menus_data = menu_manager.run()

---

## Quad Menu Example

    quad_definition = MenuDefinition_v type:#quad title:"My Tool Quad"
    quad_definition.data = #()

    quad_top_right = quad_definition.addQuad "Top Right" position:#TopRight
    quad_top_right.addItem "My Category" "My_Macro_01" title:"Top Right Action"

    quad_top_left = quad_definition.addQuad "Top Left" position:#TopLeft
    quad_top_left.addItem "My Category" "My_Macro_02" title:"Top Left Action"

    quad_bottom_left = quad_definition.addQuad "Bottom Left" position:#BottomLeft
    quad_bottom_left.addItem "My Category" "My_Macro_03" title:"Bottom Left Action"

    quad_bottom_right = quad_definition.addQuad "Bottom Right" position:#BottomRight
    quad_bottom_right.addItem "My Category" "My_Macro_04" title:"Bottom Right Action"

    menu_manager = MenuBuildManager_v menus_data:#(quad_definition)
    saved_menus_data = menu_manager.run()

---

## Single Quadrant Quad Menu Example

    quad_definition = MenuDefinition_v type:#quad title:"My Simple Quad"

    quad_definition.addItem "My Category" "My_Macro_01" title:"Quad Action 1"
    quad_definition.addItem "My Category" "My_Macro_02" title:"Quad Action 2"

    menu_manager = MenuBuildManager_v menus_data:#(quad_definition)
    saved_menus_data = menu_manager.run()

This creates a quad using the default quad position stored in the definition.

---

## Multiple Tool Workflow Example

    tool_a_menu = MenuDefinition_v type:#menu title:"Tool A"
    tool_a_menu.addItem "Tool A Category" "Tool_A_Run" title:"Run Tool A"

    tool_a_manager = MenuBuildManager_v menus_data:#(tool_a_menu)
    tool_a_manager.run()


    tool_b_menu = MenuDefinition_v type:#menu title:"Tool B"
    tool_b_menu.addItem "Tool B Category" "Tool_B_Run" title:"Run Tool B"

    tool_b_manager = MenuBuildManager_v menus_data:#(tool_b_menu)
    tool_b_manager.run()

Both menus are stored in the same JSON file.

The second call does not remove the first menu.

---

## JSON Management

## Open JSON Manager UI

    openMenuBuildManagerJsonRollout()

---

## Clear JSON File

    menu_manager = MenuBuildManager_v()
    menu_manager.clearJsonFile()

This writes a valid empty JSON structure.

---

## Delete All Menus From JSON

    menu_manager = MenuBuildManager_v()
    menu_manager.deleteAllMenusFromJson()

This is an alias for clearing the JSON menu entries.

---

## Load Saved Menu Data From JSON

    menu_manager = MenuBuildManager_v()
    saved_menus_data = menu_manager.loadSavedMenusDataFromJson()

---

## Re-register Callbacks From JSON

    menu_manager = MenuBuildManager_v()
    menu_manager.saved_menus_data = menu_manager.loadSavedMenusDataFromJson()
    menu_manager.registerCallback()

---

## Test Calls

## Test Menu and Quad Together

    saved_menus_data = testMenuBuildManagerMass()
    printSavedMenusData saved_menus_data

---

## Test Generated Dictionary Data

    saved_menus_data = testMenuBuildManagerGenerated()
    printSavedMenusData saved_menus_data

---

## Test Loading From JSON

    saved_menus_data = testMenuBuildManagerFromJson()
    printSavedMenusData saved_menus_data

---

## Test Multiple Tool Merge

    saved_menus_data = testMenuBuildManagerMultipleTools()
    printSavedMenusData saved_menus_data

---

## Open JSON Rollout

    openMenuBuildManagerJsonRollout()

---

## Clear JSON

    menu_manager = MenuBuildManager_v()
    menu_manager.clearJsonFile()

---

## What Happens On `run()`

Calling:

    menu_manager.run()

does this:

1. builds saved menu data from `MenuDefinition_v`
2. loads existing JSON
3. merges new data into existing JSON
4. saves JSON
5. registers callbacks for this session
6. saves startup loader file
7. returns `saved_menus_data`

---

## What Gets Merged

Merging is based on:

    menu type + menu title

So this replaces the old saved menu with the same title and type:

    MenuDefinition_v type:#menu title:"My Menu"

But this is a different entry:

    MenuDefinition_v type:#quad title:"My Menu"

because one is `#menu` and one is `#quad`.

---

## What Gets Skipped

A menu definition with no title is skipped:

    MenuDefinition_v type:#menu

A JSON menu entry with no title is skipped.

A menu with no valid title is never rebuilt.

---

## Current Session vs Startup

Adding or deleting JSON data affects the saved rebuild source.

Visible menus already created in the current 3ds Max session may remain until:

- CUI rebuild
- callback reload
- 3ds Max restart
- manual menu deletion logic

The JSON manager rollout edits the JSON file, not necessarily the currently visible menu UI.

---

## Summary

`MenuRebuilder.ms` provides:

- front-end menu definition API
- normal menu creation
- quad menu creation
- submenu support
- macro item support
- shared JSON storage
- multi-tool JSON merge workflow
- startup rebuild workflow
- JSON manager rollout
- delete selected menus from JSON
- delete all menus from JSON
- clear JSON file method
- strict no-title/no-menu behavior

It is intended as a shared menu infrastructure for multiple independent 3ds Max tools.