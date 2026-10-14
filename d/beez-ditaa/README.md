# ditaa

Official ditaa plugin — convert ASCII art to PNG from `*.ditaa` files or markdown ditaa blocks.

Plugin ID: **`coditary/ditaa`**

## Install

```lua
reqpack { beez = { { name = "coditary/ditaa", version = "1.0.0", source = "github:Coditary/beez-ditaa" } } }
```

## Usage

```lua
configure({ { "coditary/ditaa", {} } })
```

```bash
beez -p compile[ditaa]
beez -s ditaa:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `ditaa` | `ditaa -h` | Verifies ditaa binary |
| compile | `ditaa` | `ditaa input output.png` | Generates `build/ditaa/bin/app.png` |
| bundle | `ditaa` | verify output | Checks rendered PNG |
| test | `ditaa` | render test output | Validates ditaa rendering |

## Detection

- Markers: `**/*.ditaa`, `**/*.md` (with ` ```ditaa ` fenced blocks)
- Entry point: first `.ditaa` file, then markdown, or `entry_source` in configure()
- Markdown ditaa blocks are extracted automatically before rendering

## License

Apache License 2.0.
