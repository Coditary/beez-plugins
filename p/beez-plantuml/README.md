# plantuml

Official PlantUML plugin — render UML diagrams (`*.puml`, `*.plantuml`) to PNG.

Plugin ID: **`coditary/plantuml`**

## Install

```lua
reqpack { beez = { { name = "coditary/plantuml", version = "1.0.0", source = "github:Coditary/beez-plantuml" } } }
```

## Usage

```lua
configure({ { "coditary/plantuml", {} } })
```

```bash
beez -p compile[plantuml]
beez -s plantuml:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `plantuml` | `plantuml -version` | Verifies PlantUML binary |
| compile | `plantuml` | `plantuml -tpng -o …` | Generates `build/plantuml/bin/app.png` |
| bundle | `plantuml` | verify output | Checks generated PNG |
| test | `plantuml` | `plantuml -checkonly …` | Syntax validation when test files exist |

## Detection

- Markers: `**/*.puml`, `**/*.plantuml`
- Entry point: first non-test diagram file, or `entry_source` in configure()
- Tests: `test/**/*.puml`, `test_*.puml`, `*_test.puml` (and `.plantuml` variants)

## License

Apache License 2.0.
