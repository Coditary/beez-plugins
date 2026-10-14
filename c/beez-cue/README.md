# cue

Official CUE plugin — export, vet, and unify CUE configuration.

Plugin ID: **`coditary/cue`**

## Install

```lua
reqpack { beez = { { name = "coditary/cue", version = "1.0.0", source = "github:Coditary/beez-cue" } } }
```

## Usage

```lua
configure({ { "coditary/cue", {} } })
```

```bash
beez -p compile[cue]
beez -s cue:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `cue` | `cue version` + `cue mod tidy` | Verifies CUE CLI and module deps |
| compile | `cue` | `cue vet` + `cue export` | Writes JSON to `build/cue/bin/` |
| bundle | `cue` | verify export | Checks exported JSON file |
| test | `cue` | `cue fmt --check` | Validates CUE formatting |

## Detection

- Markers: `**/*.cue`, `cue.mod/module.cue`
- Entry point: `cue.mod/module.cue`, `main.cue`, `config.cue`, then first non-test `*.cue`, or `entry_source` in configure()

## License

Apache License 2.0.
