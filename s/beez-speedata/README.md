# speedata

Official Speedata Publisher compiler — `sp` XML-to-PDF with auto-detected `layout.xml` and data XML.

Plugin ID: **`coditary/speedata`**

## Install

```lua
reqpack { beez = { { name = "coditary/speedata", version = "1.0.0", source = "github:Coditary/beez-speedata" } } }
```

## Usage

```lua
configure({ { "coditary/speedata", {} } })
```

```bash
beez -p compile[speedata]
beez -s speedata:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `speedata` | `sp --version` | Verifies Speedata Publisher binary |
| compile | `speedata` | `sp --layout=layout.xml --output=build/speedata/out/main.pdf main.xml` | XML to PDF |
| bundle | `speedata` | verify PDF | Checks `build/speedata/out/main.pdf` |
| test | `speedata` | publish test `.xml` files | Skipped when no test files are detected |

## Detection

- Markers: `**/*.xml`, `layout.xml`
- Entry points: `main.xml`, `document.xml`, or first non-layout root `*.xml`
- Layout: `layout.xml` or first `**/layout.xml`
- Tests: `tests/**/*.xml`, `test/**/*.xml`, `*_test.xml`

## License

Apache License 2.0.
