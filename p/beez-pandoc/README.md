# pandoc

Official Pandoc document transpiler with auto-detected entry point and `pandoc.yaml` support.

Plugin ID: **`coditary/pandoc`**

## Install

```lua
reqpack { beez = { { name = "coditary/pandoc", version = "1.0.0", source = "github:Coditary/beez-pandoc" } } }
```

## Usage

```lua
configure({ { "coditary/pandoc", {} } })
```

```bash
beez -p compile[pandoc]
beez -s pandoc:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `pandoc` | `pandoc --version` | Verifies Pandoc binary |
| compile | `pandoc` | `pandoc input.md -o build/pandoc/out/app.html` | HTML output |
| bundle | `pandoc` | verify output | Checks `build/pandoc/out/app.html` |
| test | `test` | `--dry-run` or skip | Skipped when no test files detected |

When `pandoc.yaml` is present, compile uses `--defaults=pandoc.yaml`.

## Detection

- Markers: `**/*.md`, `**/*.rst`, `pandoc.yaml`
- Entry points: `main.md`, `index.md`, `README.md`, or first root document
- Defaults: `pandoc.yaml` in project root

## License

Apache License 2.0.
