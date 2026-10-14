# bcpl

Official BCPL compiler plugin — `bcpl` with auto-detected targets.

Plugin ID: **`coditary/bcpl`**

## Install

```lua
reqpack { beez = { { name = "coditary/bcpl", version = "1.0.0", source = "github:Coditary/beez-bcpl" } } }
```

## Usage

```lua
configure({ { "coditary/bcpl", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[bcpl]
beez -s coditary/bcpl:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `bcpl` | Creates `build/bcpl/.bcpl-setup` |
| compile | `bcpl` | Output under `build/bcpl/` |
| bundle | verify artifacts | Checks compile outputs |
| test | verify build output | Writes `report/test/bcpl-*.ok` |

## Detection

- Markers: `**/*.b`
- Compile targets: all non-test source files

## License

Apache License 2.0.
