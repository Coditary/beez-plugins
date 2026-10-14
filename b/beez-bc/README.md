# bc

Official bc calculator plugin — `bc -q` parse check with auto-detected `*.bc` targets.

Plugin ID: **`coditary/bc`**

## Install

```lua
reqpack { beez = { { name = "coditary/bc", version = "1.0.0", source = "github:Coditary/beez-bc" } } }
```

## Usage

```lua
configure({ { "coditary/bc", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[bc]
beez -s coditary/bc:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `bc` | Creates `build/bc/.bc-setup` |
| compile | `bc -q` | Parses all non-test `*.bc` files |
| bundle | verify compile stamp | Checks `build/bc/.bc-compile-*` |
| test | `bc -q` | Evaluates primary bc script |

## Detection

- Markers: `**/*.bc`
- Entry points: `main.bc` or first non-test `*.bc`
- Binary: `bc` (override with `BC` env or `bc_binary` config)

## License

Apache License 2.0.
