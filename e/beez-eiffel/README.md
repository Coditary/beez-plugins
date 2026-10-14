# eiffel

Official Eiffel compiler plugin — ISE EiffelStudio with auto-detected source targets.

Plugin ID: **`coditary/eiffel`**

## Install

```lua
reqpack { beez = { { name = "coditary/eiffel", version = "1.0.0", source = "github:Coditary/beez-eiffel" } } }
```

## Usage

```lua
configure({ { "coditary/eiffel", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[eiffel]
beez -s eiffel:compile
```

## Steps

| Phase | Tool | Notes |
|-------|------|-------|
| setup | `ec` | Verify compiler and prepare `build/eiffel/` |
| compile | `ec` | Compile via `ec -batch` (per `.ecf` config or each `.e` source). |
| bundle | verify artifacts | Checks outputs under `build/eiffel/` |
| test | `prove -l t/` | Writes `report/test/eiffel-*.ok` |

## Detection

- Markers: `**/*.e`, `*.ecf`, `**/*.ecf`
- Scope: `eiffel`
- Binary: `ec` (override with `EC` env or `eiffel_binary` config)

## License

Apache License 2.0.
