# MenuRebuilder Codex Instructions

## Project
MaxScript framework for Autodesk 3ds Max 2026+ custom CUI normal menus and quad menus.

Stable baseline: **0.09**. Treat 0.09 as the last known stable version. Do not regress to older chat/code variants.

## Read first
Before editing code, read:
- `docs/CURRENT_STATE.md`
- `docs/ARCHITECTURE.md`
- `docs/CODE_STYLE.md`

## Main source
Primary implementation file: `MenuRebuilder.ms`.

When working in an existing repository, locate the actual current `MenuRebuilder.ms` and inspect it before editing. Do not reconstruct the entire file from memory if a local source exists.

## Core rules
- Target 3ds Max 2026+. No 2025 compatibility work is required unless explicitly requested.
- Use MaxScript.
- Function names: camelCase.
- Variables: snake_case.
- Use `this.` consistently for struct properties and struct methods.
- Prefer `Dictionary #string` for string-key dictionaries.
- Prefer `Dictionary #name` for saved internal menu data.
- Avoid unnecessary outer parentheses.
- Do not invent default menu titles. **No title = no menu.**
- Do not use `_TEST_MENU` or any other fallback title in production paths.
- Tests may use clearly test-specific titles.
- If more than two code fragments would need replacement, return/edit the whole affected file rather than a patch maze.
- Preserve visible section banners in the single-file implementation.

## Important 3ds Max 2026 CUI facts
- `CuiMenu.CreateAction` takes 3 arguments in this runtime.
- Correct form:
  `parent_menu.CreateAction saved_guid 647394 persistent_action_id`
- Persistent action id format:
  `macro_name + "`" + macro_category`
- Do not pass an action title as a fourth `CreateAction` argument.
- Do not use `GetMenuItems()` on `<MixinInterface:CuiMenu>`; it errored in this runtime.
- Normal root menu deletion uses persisted root GUID:
  `main_menu_bar.DeleteItem menu_id`

## Architecture constraints
- `MenuDefinition_v` describes menu/quad definitions.
- `MenuBuildManager_v` owns shared JSON persistence and callback routing.
- `MenuRebuilder_v` is a pure worker that rebuilds saved `menu_data` into the passed CUI manager.
- Normal menus are rebuilt only from `#cuiRegisterMenus`.
- Quad menus are rebuilt only from `#cuiRegisterQuadMenus`.
- Never route quad data into the normal main menu bar.
- Menu definitions can be contributed by multiple tools. Each tool must merge its own saved menu data into the shared JSON instead of replacing unrelated entries.
- All saved menus are rebuilt from JSON on 3ds Max startup.

## Shared JSON behavior
- File: `MenuRebuilder_data.json` in the user startup scripts directory unless the current source defines another path.
- Root JSON contains `menus: [...]`.
- Existing entries are merged by menu type + title.
- Same type + same title replaces the previous saved definition.
- Different menus from other tools remain intact.
- Missing/empty title is invalid and must be skipped.
- Manager supports clearing the JSON and deleting selected menu entries from JSON.

## UI behavior
The framework contains/should contain a JSON manager rollout with two `multiListBox` controls:
- normal menus by title
- quad menus by title

It supports:
- refresh
- delete selected entries from JSON
- delete all / clear JSON

## Change discipline
- Increment version by `0.01` only for meaningful framework changes.
- Stable baseline is 0.09. Next meaningful version should be 0.10.
- Before changing architecture, inspect how 0.09 currently behaves locally.
- Prefer small, structural fixes over adding redundant compatibility properties.
