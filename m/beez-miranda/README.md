# Miranda

Miranda functional language — mira validation for auto-detected *.mir targets

Plugin ID: **`coditary/miranda`**

## Install

```lua
reqpack { beez = { { name = "coditary/miranda", version = "1.0.0", source = "github:Coditary/beez-miranda" } } }
```

## Usage

```lua
configure({ { "coditary/miranda", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[miranda]
beez -s coditary/miranda:compile:code
```

## Detection

- Markers: `**/*.mir`
- Binary: `mira` (override with `MIRA` env or config)

## License

Apache License 2.0.
