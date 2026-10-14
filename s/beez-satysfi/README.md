# satysfi

Official SATySFi plugin — compile OCaml typesetting documents (`*.saty`) to PDF.

Plugin ID: **`coditary/satysfi`**

## Install

```lua
reqpack { beez = { { name = "coditary/satysfi", version = "1.0.0", source = "github:Coditary/beez-satysfi" } } }
```

## Usage

```lua
configure({ { "coditary/satysfi", {} } })
```

```bash
beez -p compile[satysfi]
beez -s satysfi:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `satysfi` | `satysfi --version` | Verifies SATySFi binary |
| compile | `satysfi` | `satysfi document.saty -o …` | Generates `build/satysfi/bin/app.pdf` |
| bundle | `satysfi` | verify output | Checks generated artifact |
| test | `satysfi` | version check | Validates document sources when test files exist |

## Detection

- Markers: `**/*.saty`, `**/*.satyg`
- Entry point: `main.saty`, `document.saty`, or `entry_source` in configure()
- Tests: `test/**/*.saty`, `*_test.saty`

## License

Apache License 2.0.
