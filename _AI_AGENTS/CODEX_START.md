# Codex Start Prompt

Continue the MenuRebuilder MaxScript project from stable version 0.09.

First:
1. Read `AGENTS.md`.
2. Read `docs/CURRENT_STATE.md`, `docs/ARCHITECTURE.md`, and `docs/CODE_STYLE.md`.
3. Locate and inspect the actual local `MenuRebuilder.ms` before changing anything.
4. Verify the local file is the stable 0.09 baseline or compare it against the documented architecture before editing.

Important:
- Do not restore old redundant `MenuRebuilder_v` or `MenuBuildManager_v` properties.
- No default menu title anywhere in production paths.
- Normal menus and quad menus must remain strictly separated by their CUI callbacks.
- Multiple tools must merge independent menu definitions into the same JSON.
- All saved menus must rebuild from JSON at Max startup.

When asked for a framework change, update the local full file rather than producing a maze of replacement snippets.
