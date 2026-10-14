# xelatex

Official XeLaTeX compiler — XeTeX engine with fontspec support and auto-detected `main.tex`.

Plugin ID: **`coditary/xelatex`**

## Install

```lua
reqpack { beez = { { name = "coditary/xelatex", version = "1.0.0", source = "github:Coditary/beez-xelatex" } } }
```

## Usage

```lua
configure({ { "coditary/xelatex", {} } })
```

```bash
beez -p compile[xelatex]
beez -s xelatex:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `xelatex` | `xelatex --version` | Verifies XeLaTeX binary |
| compile | `xelatex` | `xelatex -output-directory=build/xelatex/out main.tex` | Two passes for references |
| bundle | `xelatex` | verify PDF | Checks `build/xelatex/out/main.pdf` |
| test | `xelatex` | compile test `.tex` files | Skipped when no test files are detected |

## Detection

- Markers: `**/*.tex`, `main.tex`
- Entry points: `main.tex`, or first root `*.tex`
- Tests: `tests/**/*.tex`, `test/**/*.tex`, `*_test.tex`

Use `\usepackage{fontspec}` in your document for Unicode and system fonts.

## License

Apache License 2.0.
