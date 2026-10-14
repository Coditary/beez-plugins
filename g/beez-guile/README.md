# guile

Official GNU Guile plugin — Scheme load check with auto-detected `*.scm` targets.

Plugin ID: **`coditary/guile`**

## Install

```lua
reqpack { beez = { { name = "coditary/guile", version = "1.0.0", source = "github:Coditary/beez-guile" } } }
```

## Usage

```lua
configure({ { "coditary/guile", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[guile]
beez -s coditary/guile:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `guile` | Creates `build/guile/.guile-setup` |
| compile | `guile --no-auto-compile -c '(load ...)'` | Load-checks all non-test `.scm` files |
| bundle | verify compile stamp | Checks `build/guile/.guile-compile-*` |
| test | `guile -s` | Runs `main.scm` or first entry |

## Detection

- Markers: `**/*.scm`
- Entry points: `main.scm`, or first non-test script
- Binary: `guile` (override with `GUILE` env or `guile_binary` config)

## License

Apache License 2.0.
