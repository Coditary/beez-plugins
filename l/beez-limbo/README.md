# limbo

Official Limbo compiler plugin — Inferno Limbo to Dis — limbo -o with auto-detected .b targets.

Plugin ID: **`coditary/limbo`**

## Install

```lua
reqpack { beez = { { name = "coditary/limbo", version = "1.0.0", source = "github:Coditary/beez-limbo" } } }
```

## Usage

```lua
configure({ { "coditary/limbo", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[limbo]
beez -s coditary/limbo:compile:code
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `limbo` | Verify toolchain, create `build/limbo/.limbo-setup` |
| compile | `limbo` | Compile sources to `build/limbo/` |
| bundle | `limbo` | Verify compile artifacts |
| test | `limbo` | Writes `report/test/limbo-*.ok` |

## Detection

- Markers: **/*.b
- Entry points: `main.b`, `src/main.b`, or first non-test `*.b`

## License

Apache License 2.0.
