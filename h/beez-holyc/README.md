# holyc

Official HolyC compiler plugin — HolyC with auto-detected source targets.

Plugin ID: **`coditary/holyc`**

## Install

```lua
reqpack { beez = { { name = "coditary/holyc", version = "1.0.0", source = "github:Coditary/beez-holyc" } } }
```

## Usage

```lua
configure({ { "coditary/holyc", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[holyc]
beez -s holyc:compile
```

## Steps

| Phase | Tool | Notes |
|-------|------|-------|
| setup | `holyc` | Verify compiler and prepare `build/holyc/` |
| compile | `holyc` | Compile via `holyc -o build/holyc/<name> <source.HC>`. |
| bundle | verify artifacts | Checks outputs under `build/holyc/` |
| test | `prove -l t/` | Writes `report/test/holyc-*.ok` |

## Detection

- Markers: `**/*.HC`
- Scope: `holyc`
- Binary: `holyc` (override with `HOLYC` env or `holyc_binary` config)

## License

Apache License 2.0.
