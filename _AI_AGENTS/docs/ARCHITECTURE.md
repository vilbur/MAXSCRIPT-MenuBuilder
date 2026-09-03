# Architecture

## 1. MenuDefinition_v
Public definition object used by tools.

Expected core properties:
- `type = #menu`
- `title = ""`
- `data`
- `_data` only if current stable source still intentionally supports it
- quad metadata such as modifier/position/context where required by the stable implementation

Rules:
- `title` has no production fallback.
- Empty title means invalid root definition.
- `addItem category macro_name title:""` adds a macro action.
- `addMenu title` adds a submenu and returns a submenu definition/handle.
- Quad root data may be an array of `MenuDefinition_v` entries, one per quadrant.
- Ordinary menu content is dictionary-based.

## 2. MenuBuildManager_v
Owns orchestration and persistence.

Responsibilities:
- convert public definitions to saved data
- generate/preserve GUIDs as required by the current implementation
- merge independent tool contributions into shared JSON
- read/write/clear shared JSON
- delete selected saved entries
- save startup loader
- register normal and quad callbacks
- route saved menu data based on saved type

Do not reintroduce old redundant single-menu constructor state such as:
- `menu_type`
- `menu_title`
- `user_menu_data`
- `saved_menu_data`
- manager-level `quad_modifier`
- manager-level `quad_position`

unless a future local implementation has a concrete reason and the user approves it.

## 3. MenuRebuilder_v
Pure saved-data worker.

Responsibilities:
- accept `menu_data`
- rebuild saved item hierarchy
- rebuild normal menu into a passed normal CUI manager
- rebuild quad menu into a passed quad CUI manager

It should not own public definition state such as root menu type/title/quad definition properties as duplicated struct members.

Normal rebuild path:
`#cuiRegisterMenus -> MenuBuildManager.loadAllMenus() -> MenuRebuilder_v.rebuildAsMainMenu()`

Quad rebuild path:
`#cuiRegisterQuadMenus -> MenuBuildManager.loadAllQuadMenus() -> MenuRebuilder_v.rebuildAsQuadMenu()`

## 4. MenuJsonIO_v
Custom JSON serializer/parser.

Responsibilities:
- saved items <-> JSON
- root saved menu data <-> JSON
- multiple menu roots under `menus`
- quad quadrant arrays

Critical rule:
`jsonRootToMenuData()` must never fabricate a title. Empty or missing title is invalid and must be skipped by higher-level loading/build logic.

## 5. Saved data model
Root saved menu data uses `Dictionary #name`, generally including:
- `#version`
- `#id`
- `#title`
- `#type`
- `#items`
- relevant quad metadata
- multi-quad data where used

`#items` uses `Dictionary #string` keyed by persistent GUID strings.

Saved action value uses `Dictionary #name`:
- `#title`
- `#category`
- `#macro`

Saved submenu value uses `Dictionary #name`:
- `#title`
- `#items`

## 6. Shared JSON merge semantics
All tools write into the same JSON.

Identity/signature:
- menu type + menu title

Behavior:
- matching signature: replace/update saved definition
- different signature: append/preserve
- invalid empty title: skip

This allows Tool A, Tool B, Tool C, etc. to register their own menus without deleting each other's persistence.
