# awk

Official GNU AWK compiler plugin — `gawk --lint` with auto-detected `*.awk` targets.

Plugin ID: **`coditary/awk`**

## Install

```lua
reqpack { beez = { { name = "coditary/awk", version = "1.0.0", source = "github:Coditary/beez-awk" } } }
```

## Usage

```lua
configure({ { "coditary/awk", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[awk]
beez -s coditary/awk:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `gawk` | Creates `build/awk/.awk-setup` |
| compile | `gawk --lint -f` | Lint-checks all non-test `*.awk` |
| bundle | verify compile stamp | Checks `build/awk/.awk-compile-*` |
| test | `gawk -f` | Runs primary AWK script |

## Detection

- Markers: `**/*.awk`
- Entry points: `main.awk`, `src/main.awk`, or first non-test `*.awk`
- Binary: `gawk` (override with `GAWK` env or `gawk_binary` config)

## License

Apache License 2.0.
