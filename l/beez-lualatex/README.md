# lualatex

Official LuaLaTeX compiler — LuaTeX engine with auto-detected `main.tex` entry point.

Plugin ID: **`coditary/lualatex`**

## Install

```lua
reqpack { beez = { { name = "coditary/lualatex", version = "1.0.0", source = "github:Coditary/beez-lualatex" } } }
```

## Usage

```lua
configure({ { "coditary/lualatex", {} } })
```

```bash
beez -p compile[lualatex]
beez -s lualatex:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `lualatex` | `lualatex --version` | Verifies LuaLaTeX binary |
| compile | `lualatex` | `lualatex -output-directory=build/lualatex/out main.tex` | Two passes for references |
| bundle | `lualatex` | verify PDF | Checks `build/lualatex/out/main.pdf` |
| test | `lualatex` | compile test `.tex` files | Skipped when no test files are detected |

## Detection

- Markers: `**/*.tex`, `main.tex`
- Entry points: `main.tex`, or first root `*.tex`
- Tests: `tests/**/*.tex`, `test/**/*.tex`, `*_test.tex`

## License

Apache License 2.0.
