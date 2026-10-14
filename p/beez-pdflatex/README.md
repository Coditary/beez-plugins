# pdflatex

Official pdfLaTeX compiler — pdfTeX engine with auto-detected `main.tex` entry point.

Plugin ID: **`coditary/pdflatex`**

## Install

```lua
reqpack { beez = { { name = "coditary/pdflatex", version = "1.0.0", source = "github:Coditary/beez-pdflatex" } } }
```

## Usage

```lua
configure({ { "coditary/pdflatex", {} } })
```

```bash
beez -p compile[pdflatex]
beez -s pdflatex:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `pdflatex` | `pdflatex --version` | Verifies pdfLaTeX binary |
| compile | `pdflatex` | `pdflatex -output-directory=build/pdflatex/out main.tex` | Two passes for references |
| bundle | `pdflatex` | verify PDF | Checks `build/pdflatex/out/main.pdf` |
| test | `pdflatex` | compile test `.tex` files | Skipped when no test files are detected |

## Detection

- Markers: `**/*.tex`, `main.tex`
- Entry points: `main.tex`, or first root `*.tex`
- Tests: `tests/**/*.tex`, `test/**/*.tex`, `*_test.tex`

## License

Apache License 2.0.
