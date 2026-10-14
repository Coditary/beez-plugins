# boo

Official Boo compiler plugin — `booc` with auto-detected targets.

Plugin ID: **`coditary/boo`**

## Install

```lua
reqpack { beez = { { name = "coditary/boo", version = "1.0.0", source = "github:Coditary/beez-boo" } } }
```

## Usage

```lua
configure({ { "coditary/boo", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[boo]
beez -s coditary/boo:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `booc` | Creates `build/boo/.boo-setup` |
| compile | `booc` | Output under `build/boo/` |
| bundle | verify artifacts | Checks compile outputs |
| test | verify build output | Writes `report/test/boo-*.ok` |

## Detection

- Markers: `**/*.boo`
- Compile targets: all non-test source files

## License

Apache License 2.0.
