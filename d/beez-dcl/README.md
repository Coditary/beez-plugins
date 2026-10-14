# dcl

OpenVMS DCL — DIGITAL Command Language for `*.com` command procedures.

Plugin ID: **`coditary/dcl`**

## Install

```lua
reqpack { beez = { { name = "coditary/dcl", version = "1.0.0", source = "github:Coditary/beez-dcl" } } }
```

## Usage

```lua
configure({ { "coditary/dcl", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[dcl]
beez -s coditary/dcl:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `dcl` | Creates `build/dcl/.dcl-setup` |
| compile | `dcl @script.com` | Validates and packages procedures under `build/dcl/bin/` |
| bundle | verify artifacts | Checks compile outputs |
| test | verify build output | Writes `report/test/dcl-*.ok` |

## Detection

- Markers: `**/*.com`
- Entry points: `main.com`, `app.com`, `build.com`, or first non-test source
- Compile targets: all non-test command procedures

## License

Apache License 2.0.
