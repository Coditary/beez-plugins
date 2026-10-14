# skribilo

Official Skribilo plugin — compile Guile/Scheme document sources (`*.skr`, `*.ss`) to PDF.

Plugin ID: **`coditary/skribilo`**

## Install

```lua
reqpack { beez = { { name = "coditary/skribilo", version = "1.0.0", source = "github:Coditary/beez-skribilo" } } }
```

## Usage

```lua
configure({ { "coditary/skribilo", {} } })
```

```bash
beez -p compile[skribilo]
beez -s skribilo:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `skribilo` | `skribilo --version` | Verifies Skribilo binary |
| compile | `skribilo` | `skribilo --target=pdf -o … …` | Generates `build/skribilo/bin/app.pdf` |
| bundle | `skribilo` | verify output | Checks generated artifact |
| test | `skribilo` | version check | Validates document sources when test files exist |

## Detection

- Markers: `**/*.skr`, `**/*.ss` with skribilo imports (`(use skribilo)`, `import skribilo`)
- Entry point: `main.skr`, `document.skr`, or `entry_source` in configure()
- Tests: `test/**/*.skr`, `test/**/*.ss`, `*_test.skr`

## License

Apache License 2.0.
