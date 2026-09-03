# Current State

## Stable baseline
Version **0.09** is the stable baseline confirmed by the user.

## Current goals already implemented by 0.09
- Normal menus and quad menus can coexist in one framework.
- Multiple tools can add independent menus into a shared JSON file.
- JSON data is merged instead of blindly overwritten.
- Menus are rebuilt from JSON on 3ds Max startup.
- `MenuBuildManager_v` has JSON-management behavior including clearing JSON.
- A rollout lists normal menus and quad menus separately and can delete selected/all JSON entries.
- Missing title must not create a menu.

## Recent bugs that were fixed / must stay fixed
1. Quad definitions were accidentally routed into the normal Menus system.
   - Keep strict callback routing.
2. `MenuRebuilder_v` previously contained redundant definition properties such as menu type/title/quad position.
   - Keep it as a worker operating on saved `menu_data`.
3. `MenuBuildManager_v` previously retained old single-menu properties and constructed `MenuRebuilder_v` with removed members.
   - Do not restore those old properties.
4. `MenuJsonIO_v.jsonRootToMenuData()` used a fallback `_TEST_MENU` title and could create an unwanted menu.
   - Missing title must stay empty/invalid and be skipped.
5. User explicitly does not want production default titles anywhere.

## User workflow
Menus are declared across multiple independent 3ds Max tools. Each tool may run separately and add its own definitions. Therefore shared persistence must be additive/merge-based.

At startup, one shared JSON source is loaded and callbacks rebuild every saved normal menu and quad menu.

## Next version
Only increment from 0.09 to 0.10 when making a meaningful framework change.
