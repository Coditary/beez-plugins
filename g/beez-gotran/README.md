# gotran

GOTRAN — IBM Fortran dialect compiler for `*.for` and `*.got` sources.

Plugin ID: **`coditary/gotran`**

## Install

```lua
reqpack { beez = { { name = "coditary/gotran", version = "1.0.0", source = "github:Coditary/beez-gotran" } } }
```

## Usage

```lua
configure({ { "coditary/gotran", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[gotran]
beez -s coditary/gotran:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `gotran` | Creates `build/gotran/.gotran-setup` |
| compile | `gotran -o` | Native binary under `build/gotran/bin/` |
| bundle | verify artifacts | Checks compile outputs |
| test | verify build output | Writes `report/test/gotran-*.ok` |

## Detection

- Markers: `**/*.for`, `**/*.got`
- Entry points: `main.for`, `main.got`, `program.for`, or first non-test source
- Compile targets: all non-test GOTRAN Fortran sources

## License

Apache License 2.0.
