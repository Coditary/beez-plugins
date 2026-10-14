# NSIS

Nullsoft Scriptable Install System — makensis compile for auto-detected *.nsi targets

Plugin ID: **`coditary/nsis`**

## Install

```lua
reqpack { beez = { { name = "coditary/nsis", version = "1.0.0", source = "github:Coditary/beez-nsis" } } }
```

## Usage

```lua
configure({ { "coditary/nsis", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[nsis]
beez -s coditary/nsis:compile:code
```

## Detection

- Markers: `**/*.nsi`
- Binary: `makensis` (override with `MAKENSIS` env or config)

## License

Apache License 2.0.
