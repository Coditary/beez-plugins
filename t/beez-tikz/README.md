# tikz

Official TikZ/PGF plugin — compile standalone `*.tikz` documents to PDF.

Plugin ID: **`coditary/tikz`**

## Install

```lua
reqpack { beez = { { name = "coditary/tikz", version = "1.0.0", source = "github:Coditary/beez-tikz" } } }
```

## Usage

```lua
configure({ { "coditary/tikz", {} } })
```

```bash
beez -p compile[tikz]
beez -s tikz:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `tikz` | `pdflatex --version` | Verifies LaTeX engine |
| compile | `tikz` | `pdflatex -jobname=app …` | Generates `build/tikz/bin/app.pdf` |
| bundle | `tikz` | verify output | Checks compiled PDF |
| test | `tikz` | compile test output | Validates TikZ rendering |

## Detection

- Markers: `**/*.tikz`
- Entry point: first non-test `.tikz` file, or `entry_source` in configure()
- Engines: pdflatex (code profile), lualatex (debug profile)

## License

Apache License 2.0.
