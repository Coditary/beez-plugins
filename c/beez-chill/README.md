# chill

Official CHILL compiler plugin — `chill` with auto-detected targets.

Plugin ID: **`coditary/chill`**

## Install

```lua
reqpack { beez = { { name = "coditary/chill", version = "1.0.0", source = "github:Coditary/beez-chill" } } }
```

## Usage

```lua
configure({ { "coditary/chill", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[chill]
beez -s coditary/chill:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `chill` | Creates `build/chill/.chill-setup` |
| compile | `chill` | Output under `build/chill/` |
| bundle | verify artifacts | Checks compile outputs |
| test | verify build output | Writes `report/test/chill-*.ok` |

## Detection

- Markers: `**/*.ch`
- Compile targets: all non-test source files

## License

Apache License 2.0.
