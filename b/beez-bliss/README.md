# bliss

Official BLISS compiler plugin — `bliss` with auto-detected targets.

Plugin ID: **`coditary/bliss`**

## Install

```lua
reqpack { beez = { { name = "coditary/bliss", version = "1.0.0", source = "github:Coditary/beez-bliss" } } }
```

## Usage

```lua
configure({ { "coditary/bliss", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[bliss]
beez -s coditary/bliss:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `bliss` | Creates `build/bliss/.bliss-setup` |
| compile | `bliss` | Output under `build/bliss/` |
| bundle | verify artifacts | Checks compile outputs |
| test | verify build output | Writes `report/test/bliss-*.ok` |

## Detection

- Markers: `**/*.bli`
- Compile targets: all non-test source files

## License

Apache License 2.0.
