# hy

Official Hy compiler plugin — `hy2py` transpile and `hy` execution with auto-detected `*.hy` targets.

Plugin ID: **`coditary/hy`**

## Install

```lua
reqpack { beez = { { name = "coditary/hy", version = "1.0.0", source = "github:Coditary/beez-hy" } } }
```

## Usage

```lua
configure({ { "coditary/hy", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[hy]
beez -s coditary/hy:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `hy` and `hy2py` | Creates `build/hy/.hy-setup` |
| compile | `hy2py` | Transpiles all non-test `.hy` to `build/hy/*.py` |
| bundle | verify compile stamp | Checks `build/hy/.hy-compile-*` |
| test | run primary script | Executes `main.hy` or first entry |

## Detection

- Markers: `**/*.hy`
- Entry points: `main.hy`, or first non-test source
- Binaries: `hy`, `hy2py` (override with `HY`/`HY2PY` env or config)

## License

Apache License 2.0.
