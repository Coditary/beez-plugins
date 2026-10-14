# QuakeC

QuakeC — FTEQCC compile for auto-detected *.qc targets

Plugin ID: **`coditary/quakec`**

## Install

```lua
reqpack { beez = { { name = "coditary/quakec", version = "1.0.0", source = "github:Coditary/beez-quakec" } } }
```

## Usage

```lua
configure({ { "coditary/quakec", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[quakec]
beez -s coditary/quakec:compile:code
```

## Detection

- Markers: `**/*.qc`
- Binary: `fteqcc` (override with `FTEQCC` env or config)

## License

Apache License 2.0.
