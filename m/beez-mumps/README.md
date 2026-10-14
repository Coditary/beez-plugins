# MUMPS

MUMPS/YottaDB — script execution for auto-detected *.mps targets

Plugin ID: **`coditary/mumps`**

## Install

```lua
reqpack { beez = { { name = "coditary/mumps", version = "1.0.0", source = "github:Coditary/beez-mumps" } } }
```

## Usage

```lua
configure({ { "coditary/mumps", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[mumps]
beez -s coditary/mumps:compile:code
```

## Detection

- Markers: `**/*.mps`
- Binary: `mumps` (override with `MUMPS` env or config)

## License

Apache License 2.0.
