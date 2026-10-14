# context

Official ConTeXt LuaTeX compiler — `context.mkiv` with auto-detected ConTeXt `.tex` entry points.

Plugin ID: **`coditary/context`**

## Install

```lua
reqpack { beez = { { name = "coditary/context", version = "1.0.0", source = "github:Coditary/beez-context" } } }
```

## Usage

```lua
configure({ { "coditary/context", {} } })
```

```bash
beez -p compile[context]
beez -s context:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `context` | `context.mkiv --version` | Verifies ConTeXt binary |
| compile | `context` | `context.mkiv --output=build/context/out main.tex` | ConTeXt document to PDF |
| bundle | `context` | verify PDF | Checks `build/context/out/main.pdf` |
| test | `context` | compile test `.tex` files | Skipped when no test files are detected |

## Detection

- Markers: `**/*.tex` with `\starttext`, `context.mkiv`
- Entry points: `main.tex`, `document.tex`, or first root `*.tex`
- Tests: `tests/**/*.tex`, `test/**/*.tex`, `*_test.tex`

## License

Apache License 2.0.
