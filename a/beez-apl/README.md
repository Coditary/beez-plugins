# apl

Official APL compiler plugin — GNU APL or Dyalog load-check with auto-detected `*.apl` targets.

Plugin ID: **`coditary/apl`**

## Install

```lua
reqpack { beez = { { name = "coditary/apl", version = "1.0.0", source = "github:Coditary/beez-apl" } } }
```

## Usage

```lua
configure({ { "coditary/apl", { apl_flavor = "gnu" } } })
-- or: { apl_flavor = "dyalog" }
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[apl]
beez -s coditary/apl:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `apl` or `dyalog` | Creates `build/apl/.apl-setup` |
| compile | `apl --script` / `dyalog -batch` | Load-checks all non-test `*.apl` |
| bundle | verify compile stamp | Checks `build/apl/.apl-compile-*` |
| test | run primary script | Executes `main.apl` or first entry |

## Detection

- Markers: `**/*.apl`
- Entry points: `main.apl` or first non-test `*.apl`
- Flavor: `gnu` (default) or `dyalog` via `apl_flavor` / `APL_FLAVOR`

## License

Apache License 2.0.
