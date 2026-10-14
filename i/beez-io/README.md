# io

Official Io language compiler plugin — `io` interpreter with auto-detected `*.io` targets.

Plugin ID: **`coditary/io`**

## Install

```lua
reqpack { beez = { { name = "coditary/io", version = "1.0.0", source = "github:Coditary/beez-io" } } }
```

## Usage

```lua
configure({ { "coditary/io", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[io]
beez -s coditary/io:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `io` | Creates `build/io/.io-setup` |
| compile | `io -e 'Lobby doFile(...)'` | Loads and validates all non-test scripts |
| bundle | verify compile stamp | Checks `build/io/.io-compile-*` |
| test | run primary script | Executes `main.io` or first entry |

## Detection

- Markers: `**/*.io`
- Entry points: `main.io`, or first non-test script
- Binary: `io` (override with `IO` env or `io_binary` config)

## License

Apache License 2.0.
