# seed7

Official seed7 compiler plugin — Seed7 — s7c to C with auto-detected **/*.sd7 and **/*.s7i.

Plugin ID: **`coditary/seed7`**

## Install

```lua
reqpack { beez = { { name = "coditary/seed7", version = "1.0.0", source = "github:Coditary/beez-seed7" } } }
```

## Usage

```lua
configure({ { "coditary/seed7", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[seed7]
beez -s seed7:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `s7c` | Prepare `build/seed7/` |
| compile | `s7c` on sources | Writes artifacts under `build/seed7/` |
| bundle | verify compile artifacts | Checks output files |
| test | verify primary output | Writes `report/test/seed7-*.ok` |

## Detection

- Markers: `**/*.sd7`, `**/*.s7i`
- Compile `.sd7` programs with `s7c -o` (`.s7i` library includes).
- Binary: `s7c` (override with `S7C` env or `seed7_binary` config)

## License

Apache License 2.0.
