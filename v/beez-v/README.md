# v

Official V language compiler — `v -o` with auto-detected main entry point.

Plugin ID: **`coditary/v`**

## Install

```lua
reqpack { beez = { { name = "coditary/v", version = "1.0.0", source = "github:Coditary/beez-v" } } }
```

## Usage

```lua
configure({ { "coditary/v", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `v version` | Verifies V compiler binary |
| compile | `v -o build/v/bin/app` | Output under `build/v/bin/` |
| bundle | verify binaries | Checks `build/v/bin/**` |
| test | `v test` | Runs V built-in test runner |

## Detection

- Markers: `v.mod`, `**/*.v`
- Entry points: `main.v`, `cmd/main/main.v`, or first root `*.v`

## License

Apache License 2.0.
