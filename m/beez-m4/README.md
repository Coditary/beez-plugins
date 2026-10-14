# GNU m4

GNU m4 macro processor with headless expansion for auto-detected *.m4 targets

Plugin ID: **`coditary/m4`**

## Install

```lua
reqpack { beez = { { name = "coditary/m4", version = "1.0.0", source = "github:Coditary/beez-m4" } } }
```

## Usage

```lua
configure({ { "coditary/m4", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[m4]
beez -s coditary/m4:compile:code
```

## Detection

- Markers: `**/*.m4`, `**/*.mc`
- Binary: `m4` (override with `M4` env or config)

## License

Apache License 2.0.
