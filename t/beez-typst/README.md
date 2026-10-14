# typst

Official Typst document compiler with auto-detected entry point.

Plugin ID: **`coditary/typst`**

## Install

```lua
reqpack { beez = { { name = "coditary/typst", version = "1.0.0", source = "github:Coditary/beez-typst" } } }
```

## Usage

```lua
configure({ { "coditary/typst", {} } })
```

```bash
beez -p compile[typst]
beez -s typst:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `typst` | `typst --version` | Verifies Typst binary |
| compile | `typst` | `typst compile main.typ build/typst/out/app.pdf` | PDF output |
| bundle | `typst` | verify output | Checks `build/typst/out/app.pdf` |
| test | `test` | compile tests or skip | Skipped when no test files detected |

## Detection

- Markers: `**/*.typ`
- Entry points: `main.typ`, `index.typ`, or first root `*.typ`

## License

Apache License 2.0.
