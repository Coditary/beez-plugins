# ceylon

Official Ceylon compiler plugin — `ceylon` with auto-detected targets.

Plugin ID: **`coditary/ceylon`**

## Install

```lua
reqpack { beez = { { name = "coditary/ceylon", version = "1.0.0", source = "github:Coditary/beez-ceylon" } } }
```

## Usage

```lua
configure({ { "coditary/ceylon", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[ceylon]
beez -s coditary/ceylon:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `ceylon` | Creates `build/ceylon/.ceylon-setup` |
| compile | `ceylon` | Output under `build/ceylon/` |
| bundle | verify artifacts | Checks compile outputs |
| test | verify build output | Writes `report/test/ceylon-*.ok` |

## Detection

- Markers: `**/*.ceylon`, `module.ceylon`, `**/module.ceylon`
- Compile targets: all non-test source files

## License

Apache License 2.0.
