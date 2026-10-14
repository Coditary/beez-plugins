# ZPL

Zebra ZPL — Labelary API render for auto-detected *.zpl label targets

Plugin ID: **`coditary/zpl`**

## Install

```lua
reqpack { beez = { { name = "coditary/zpl", version = "1.0.0", source = "github:Coditary/beez-zpl" } } }
```

## Usage

```lua
configure({ { "coditary/zpl", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[zpl]
beez -s coditary/zpl:compile:code
```

## Detection

- Markers: `**/*.zpl`
- Binary: `curl` (override with `CURL` env or config)

## License

Apache License 2.0.
