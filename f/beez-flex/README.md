# flex

Official GNU Flex plugin — generate C lexers from Flex specification files.

Plugin ID: **`coditary/flex`**

## Install

```lua
reqpack { beez = { { name = "coditary/flex", version = "1.0.0", source = "github:Coditary/beez-flex" } } }
```

## Usage

```lua
configure({ { "coditary/flex", {} } })
```

```bash
beez -p compile[flex]
beez -s flex:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `flex` | `flex --version` | Verifies Flex binary |
| compile | `flex` | `flex -o …` | Generates `build/flex/bin/lex.yy.c` |
| bundle | `flex` | verify output | Checks generated lexer |
| test | `flex` | dry-run generation | Validates lexer specification |

## Detection

- Markers: `**/*.l`, `**/*.lex`
- Entry point: `lexer.l` / `scanner.l`, or first non-test lexer file, or `entry_source` in configure()
- Output: `lex.yy.c` (code profile), `--debug` flags (debug profile)

## License

Apache License 2.0.
