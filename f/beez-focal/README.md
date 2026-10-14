# focal

FOCAL — 1960s Formula Calculator language for `*.fcl` and `*.focal` sources.

Plugin ID: **`coditary/focal`**

## Install

```lua
reqpack { beez = { { name = "coditary/focal", version = "1.0.0", source = "github:Coditary/beez-focal" } } }
```

## Usage

```lua
configure({ { "coditary/focal", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[focal]
beez -s coditary/focal:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `focal` | Creates `build/focal/.focal-setup` |
| compile | `focal -o` | Listing output under `build/focal/bin/` |
| bundle | verify artifacts | Checks compile outputs |
| test | verify build output | Writes `report/test/focal-*.ok` |

## Detection

- Markers: `**/*.fcl`, `**/*.focal`
- Entry points: `main.fcl`, `main.focal`, `app.fcl`, or first non-test source
- Compile targets: all non-test FOCAL programs

## License

Apache License 2.0.
