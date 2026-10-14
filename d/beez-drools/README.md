# drools

Official Drools plugin — compile business rules (`*.drl`, `*.dsl`) to KJAR.

Plugin ID: **`coditary/drools`**

## Install

```lua
reqpack { beez = { { name = "coditary/drools", version = "1.0.0", source = "github:Coditary/beez-drools" } } }
```

## Usage

```lua
configure({ { "coditary/drools", {} } })
```

```bash
beez -p compile[drools]
beez -s drools:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `drools` | `drools --version` | Verifies Drools compiler binary |
| compile | `drools` | `drools build -o …` | Builds `build/drools/bin/rules.jar` |
| bundle | `drools` | verify output | Checks compiled KJAR |
| test | `drools` | `drools validate` | Validates rules when test files exist |

## Detection

- Markers: `**/*.drl`, `**/*.dsl`
- Entry point: first non-test `*.drl`, or `entry_source` in configure()
- DSL: first non-test `*.dsl`, or `dsl_source` in configure()
- Tests: `test/**/*.drl`, `test/**/*.dsl`

## License

Apache License 2.0.
