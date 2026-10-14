# structurizr

Official Structurizr plugin — validate and export C4 architecture workspace DSL files.

Plugin ID: **`coditary/structurizr`**

## Install

```lua
reqpack { beez = { { name = "coditary/structurizr", version = "1.0.0", source = "github:Coditary/beez-structurizr" } } }
```

## Usage

```lua
configure({ { "coditary/structurizr", {} } })
```

```bash
beez -p compile[structurizr]
beez -s structurizr:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `structurizr` | `structurizr-cli validate` | Verifies CLI and workspace DSL |
| compile | `structurizr` | `structurizr-cli export …` | Exports diagrams to `build/structurizr/bin/` |
| bundle | `structurizr` | verify output | Checks export stamp |
| test | `structurizr` | validate workspace | Validates Structurizr DSL |

## Detection

- Markers: `workspace.dsl`, `**/*.dsl`
- Entry point: `workspace.dsl`, then first non-test `*.dsl`, or `entry_source` in configure()
- Export: PlantUML (code profile), Mermaid (debug profile)

## License

Apache License 2.0.
