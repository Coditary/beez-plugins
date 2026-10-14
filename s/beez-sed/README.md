# GNU sed

GNU sed stream editor — script validation for auto-detected *.sed targets

Plugin ID: **`coditary/sed`**

## Install

```lua
reqpack { beez = { { name = "coditary/sed", version = "1.0.0", source = "github:Coditary/beez-sed" } } }
```

## Usage

```lua
configure({ { "coditary/sed", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[sed]
beez -s coditary/sed:compile:code
```

## Detection

- Markers: `**/*.sed`
- Binary: `sed` (override with `SED` env or config)

## License

Apache License 2.0.
