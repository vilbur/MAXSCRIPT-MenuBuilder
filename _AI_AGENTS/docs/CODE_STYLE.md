# Code Style

## MaxScript naming
- functions: `camelCase`
- variables: `snake_case`
- structs: existing `_v` suffix convention, e.g. `MenuRebuilder_v`

## Struct access
Inside structs, consistently use:
- `this.property`
- `this.method()` / `this.method arg`

Do not randomly mix direct property access and `this.`.

## Dictionaries
Use:
- `Dictionary #string` for title/GUID/string-key structures
- `Dictionary #name` for saved named-field records

`HasDictValue` is typed. A `#name` lookup on `Dictionary #string` can raise a runtime error. Use the existing safe helper when dictionary key type is uncertain.

## Formatting
- Keep visible file section banners.
- Avoid redundant parentheses around whole expressions.
- Prefer readable explicit branches over clever compressed expressions when MaxScript precedence may be ambiguous.
- Keep comments useful and short.

## Full-file preference
The user strongly prefers error-resistant delivery:
- one or two small replacements: snippets are acceptable
- more than two replacements: provide/update the whole affected file

## Titles
Production code must not contain fallback root menu titles such as `_TEST_MENU`.

No title = no menu.

Test-only names should be obviously test-specific and isolated in the tests section.
