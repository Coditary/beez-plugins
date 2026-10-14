# malbolge

Official Malbolge compiler plugin — experimental AOT with auto-detected targets.

Plugin ID: **`coditary/malbolge`**

## Install

```lua
reqpack { beez = { { name = "coditary/malbolge", version = "1.0.0", source = "github:Coditary/beez-malbolge" } } }
```

## Usage

```lua
configure({ { "coditary/malbolge", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[malbolge]
beez -s coditary/malbolge:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `malbolge-aot` | Creates `build/malbolge/.malbolge-setup` |
| compile | `malbolge-aot -o …` | Native binary under `build/malbolge/bin/` |
| bundle | verify artifacts | Checks compile outputs |
| test | verify build output | Writes `report/test/malbolge-*.ok` |

## Detection

- Markers: `**/*.mal`
- Entry points: `main.mal`, `app.mal`, or first non-test source
- Compile targets: all non-test source files

## License

Apache License 2.0.
