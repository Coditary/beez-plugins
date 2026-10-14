# REXX

Regina REXX — script execution for auto-detected *.rexx and *.rex targets

Plugin ID: **`coditary/rexx`**

## Install

```lua
reqpack { beez = { { name = "coditary/rexx", version = "1.0.0", source = "github:Coditary/beez-rexx" } } }
```

## Usage

```lua
configure({ { "coditary/rexx", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[rexx]
beez -s coditary/rexx:compile:code
```

## Detection

- Markers: `**/*.rexx`, `**/*.rex`
- Binary: `rexx` (override with `REXX` env or config)

## License

Apache License 2.0.
