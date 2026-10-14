# logo

Official UCBLogo turtle compiler plugin — `logo -g -b` with auto-detected `*.logo`/`*.lgo` targets.

Plugin ID: **`coditary/logo`**

## Install

```lua
reqpack { beez = { { name = "coditary/logo", version = "1.0.0", source = "github:Coditary/beez-logo" } } }
```

## Usage

```lua
configure({ { "coditary/logo", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[logo]
beez -s coditary/logo:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `logo` | Creates `build/logo/.logo-setup` |
| compile | `logo -g -b` | Runs all non-test Logo scripts in batch mode |
| bundle | verify compile stamp | Checks `build/logo/.logo-compile-*` |
| test | run primary script | Executes `main.logo`/`main.lgo` or first entry |

## Detection

- Markers: `**/*.logo`, `**/*.lgo`
- Entry points: `main.logo`, `main.lgo`, or first non-test script
- Binary: `logo` (override with `LOGO` env or `logo_binary` config)

## License

Apache License 2.0.
