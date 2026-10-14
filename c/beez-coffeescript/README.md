# coffeescript

Official CoffeeScript compiler plugin — `coffee` with auto-detected targets.

Plugin ID: **`coditary/coffeescript`**

## Install

```lua
reqpack { beez = { { name = "coditary/coffeescript", version = "1.0.0", source = "github:Coditary/beez-coffeescript" } } }
```

## Usage

```lua
configure({ { "coditary/coffeescript", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[coffeescript]
beez -s coditary/coffeescript:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `coffee` | Creates `build/coffeescript/.coffeescript-setup` |
| compile | `coffee` | Output under `build/coffeescript/` |
| bundle | verify artifacts | Checks compile outputs |
| test | verify build output | Writes `report/test/coffeescript-*.ok` |

## Detection

- Markers: `**/*.coffee`
- Compile targets: all non-test source files

## License

Apache License 2.0.
