# chapel

Official Chapel compiler plugin — `chpl` with auto-detected targets.

Plugin ID: **`coditary/chapel`**

## Install

```lua
reqpack { beez = { { name = "coditary/chapel", version = "1.0.0", source = "github:Coditary/beez-chapel" } } }
```

## Usage

```lua
configure({ { "coditary/chapel", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[chapel]
beez -s coditary/chapel:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `chpl` | Creates `build/chapel/.chapel-setup` |
| compile | `chpl` | Output under `build/chapel/` |
| bundle | verify artifacts | Checks compile outputs |
| test | verify build output | Writes `report/test/chapel-*.ok` |

## Detection

- Markers: `**/*.chpl`, `Chapel.toml`, `**/Chapel.toml`
- Compile targets: all non-test source files

## License

Apache License 2.0.
