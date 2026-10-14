# dynamo

DYNAMO — continuous-system simulation language for `*.dym` and `*.dyn` models.

Plugin ID: **`coditary/dynamo`**

## Install

```lua
reqpack { beez = { { name = "coditary/dynamo", version = "1.0.0", source = "github:Coditary/beez-dynamo" } } }
```

## Usage

```lua
configure({ { "coditary/dynamo", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[dynamo]
beez -s coditary/dynamo:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `dynamo` | Creates `build/dynamo/.dynamo-setup` |
| compile | `dynamo -o` | Simulation output under `build/dynamo/bin/` |
| bundle | verify artifacts | Checks compile outputs |
| test | verify build output | Writes `report/test/dynamo-*.ok` |

## Detection

- Markers: `**/*.dym`, `**/*.dyn`
- Entry points: `main.dym`, `model.dym`, `main.dyn`, or first non-test source
- Compile targets: all non-test DYNAMO simulation models

## License

Apache License 2.0.
