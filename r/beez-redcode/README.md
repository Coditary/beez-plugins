# Redcode

Core War Redcode — pMARS batch simulation for auto-detected *.red targets

Plugin ID: **`coditary/redcode`**

## Install

```lua
reqpack { beez = { { name = "coditary/redcode", version = "1.0.0", source = "github:Coditary/beez-redcode" } } }
```

## Usage

```lua
configure({ { "coditary/redcode", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[redcode]
beez -s coditary/redcode:compile:code
```

## Detection

- Markers: `**/*.red`
- Binary: `pmars` (override with `PMARS` env or config)

## License

Apache License 2.0.
