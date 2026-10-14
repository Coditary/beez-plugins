# rc

Plan 9 rc shell — script execution for auto-detected rc scripts

Plugin ID: **`coditary/rc`**

## Install

```lua
reqpack { beez = { { name = "coditary/rc", version = "1.0.0", source = "github:Coditary/beez-rc" } } }
```

## Usage

```lua
configure({ { "coditary/rc", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[rc]
beez -s coditary/rc:compile:code
```

## Detection

- Markers: `**/rc/**/*.rc`, `**/*.rc`
- Binary: `rc` (override with `RC` env or config)

## License

Apache License 2.0.
