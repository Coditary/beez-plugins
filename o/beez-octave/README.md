# octave

GNU Octave — `octave --check` with auto-detected `*.m` targets.

Plugin ID: **`coditary/octave`**

## Install

```lua
reqpack { beez = { { name = "coditary/octave", version = "1.0.0", source = "github:Coditary/beez-octave" } } }
```

## Usage

```lua
configure({ { "coditary/octave", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[octave]
beez -s coditary/octave:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `octave` | Creates `build/octave/.octave-setup` |
| compile | `octave --check` | Syntax-checks all non-test `.m` files |
| bundle | verify compile stamp | Checks `build/octave/.octave-compile-*` |
| test | `octave --eval run(...)` | Runs `main.m` or first entry |

## Detection

- Markers: `**/*.m`
- Entry points: `main.m`, `src/main.m`, or first non-test script
- Binary: `octave` (override with `OCTAVE` env or `octave_binary` config)
- Scope: `octave`

## License

Apache License 2.0.
