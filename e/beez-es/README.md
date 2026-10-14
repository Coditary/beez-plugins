# es

Extensible Shell (es) — parse-check with auto-detected `*.es` targets.

Plugin ID: **`coditary/es`**

## Install

```lua
reqpack { beez = { { name = "coditary/es", version = "1.0.0", source = "github:Coditary/beez-es" } } }
```

## Usage

```lua
configure({ { "coditary/es", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[es]
beez -s coditary/es:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `es` | Creates `build/es/.es-setup` |
| compile | `es -e '. ./script.es'` | Parse-checks all non-test scripts |
| bundle | verify compile stamp | Checks `build/es/.es-compile-*` |
| test | run primary script | Executes `main.es` or first entry |

## Detection

- Markers: `**/*.es`
- Entry points: `main.es`, `src/main.es`, or first non-test script
- Binary: `es` (override with `ES` env or `es_binary` config)
- Scope: `es`

## License

Apache License 2.0.
