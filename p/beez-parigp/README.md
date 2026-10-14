# PARI/GP

PARI/GP computer algebra — gp -q -f batch for auto-detected *.parigp scripts

Plugin ID: **`coditary/parigp`**

## Install

```lua
reqpack { beez = { { name = "coditary/parigp", version = "1.0.0", source = "github:Coditary/beez-parigp" } } }
```

## Usage

```lua
configure({ { "coditary/parigp", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[parigp]
beez -s coditary/parigp:compile:code
```

## Detection

- Markers: `**/*.parigp`, `**/pari/**/*.gp`
- Binary: `gp` (override with `GP` env or config)

## License

Apache License 2.0.
