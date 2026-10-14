# dhall

Official Dhall plugin — evaluate configuration expressions to JSON or YAML.

Plugin ID: **`coditary/dhall`**

## Install

```lua
reqpack { beez = { { name = "coditary/dhall", version = "1.0.0", source = "github:Coditary/beez-dhall" } } }
```

## Usage

```lua
configure({ { "coditary/dhall", {} } })
```

```bash
beez -p compile[dhall]
beez -s dhall:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `dhall` | `dhall resolve` | Verifies Dhall CLI and resolves imports |
| compile | `dhall` | `dhall-to-json` / `dhall-to-yaml` | Exports to `build/dhall/bin/` |
| bundle | `dhall` | verify export | Checks JSON/YAML output file |
| test | `dhall` | `dhall format --check` | Validates Dhall expression formatting |

## Detection

- Markers: `**/*.dhall`
- Entry point: `config.dhall`, `main.dhall`, `package.dhall`, then first non-test `*.dhall`, or `entry_source` in configure()
- Release profile exports JSON; debug profile exports YAML

## License

Apache License 2.0.
