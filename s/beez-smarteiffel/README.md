# smarteiffel

Official SmartEiffel compiler plugin — SmartEiffel with auto-detected source targets.

Plugin ID: **`coditary/smarteiffel`**

## Install

```lua
reqpack { beez = { { name = "coditary/smarteiffel", version = "1.0.0", source = "github:Coditary/beez-smarteiffel" } } }
```

## Usage

```lua
configure({ { "coditary/smarteiffel", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[smarteiffel]
beez -s smarteiffel:compile
```

## Steps

| Phase | Tool | Notes |
|-------|------|-------|
| setup | `se` | Verify compiler and prepare `build/smarteiffel/` |
| compile | `se` | Transpile via `se -c` (SmartEiffel → C). |
| bundle | verify artifacts | Checks outputs under `build/smarteiffel/` |
| test | `prove -l t/` | Writes `report/test/smarteiffel-*.ok` |

## Detection

- Markers: `**/*.e`
- Scope: `smarteiffel`
- Binary: `se` (override with `SE` env or `smarteiffel_binary` config)

## License

Apache License 2.0.
