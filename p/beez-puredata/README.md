# Pure Data

Pure Data (pd) — headless patch validation for auto-detected *.pd targets

Plugin ID: **`coditary/puredata`**

## Install

```lua
reqpack { beez = { { name = "coditary/puredata", version = "1.0.0", source = "github:Coditary/beez-puredata" } } }
```

## Usage

```lua
configure({ { "coditary/puredata", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[puredata]
beez -s coditary/puredata:compile:code
```

## Detection

- Markers: `**/*.pd`
- Binary: `pd` (override with `PD` env or config)

## License

Apache License 2.0.
