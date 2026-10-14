# labview

Official LabVIEW compiler plugin — compile VIs with LabVIEWCLI, auto-detected **/*.vi.

Plugin ID: **`coditary/labview`**

## Install

```lua
reqpack { beez = { { name = "coditary/labview", version = "1.0.0", source = "github:Coditary/beez-labview" } } }
```

## Usage

```lua
configure({ { "coditary/labview", {} } })
workflows({ build = "coditary/labview:build" })
```

```bash
beez build
beez -p compile[labview]
beez -s labview:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `labview` | Verify `LabVIEWCLI` toolchain |
| compile | `labview` | Compile detected sources |
| bundle | `labview` | Verify build artifacts under `build/labview/bin/` |
| test | `labview` | Run primary output or write test stamp |

## Detection

- Markers: `**/*.vi`
- Compile targets: auto-detected entry points via `ctx.glob`
- Binary: `LabVIEWCLI` (override with `LABVIEWCLI` env or `labviewcli_binary` config)

## License

Apache License 2.0.
