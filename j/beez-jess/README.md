# jess

Official Jess expert system compiler plugin — `jess` batch loader with auto-detected `*.clp` targets.

Plugin ID: **`coditary/jess`**

## Install

```lua
reqpack { beez = { { name = "coditary/jess", version = "1.0.0", source = "github:Coditary/beez-jess" } } }
```

## Usage

```lua
configure({ { "coditary/jess", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[jess]
beez -s coditary/jess:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `jess` and `java` | Creates `build/jess/.jess-setup` |
| compile | `(batch "...") (exit)` via `jess -nobanner` | Loads and validates all CLP sources |
| bundle | verify compile stamp | Checks `build/jess/.jess-compile-*` |
| test | batch-run primary script | Executes `main.clp` or first entry |

## Detection

- Markers: `**/*.clp`
- Entry points: `main.clp`, or first non-test script
- Binaries: `jess`, `java` (override with `JESS`/`JAVA` env)

## License

Apache License 2.0.
