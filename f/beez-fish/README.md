# fish

Official fish shell plugin — `fish -n` syntax check with auto-detected `*.fish` targets.

Plugin ID: **`coditary/fish`**

## Install

```lua
reqpack { beez = { { name = "coditary/fish", version = "1.0.0", source = "github:Coditary/beez-fish" } } }
```

## Usage

```lua
configure({ { "coditary/fish", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[fish]
beez -s coditary/fish:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `fish` | Creates `build/fish/.fish-setup` |
| compile | `fish -n` | Syntax-checks all non-test scripts |
| bundle | verify compile stamp | Checks `build/fish/.fish-compile-*` |
| test | run primary script | Executes `main.fish` or first entry |

## Detection

- Markers: `**/*.fish`
- Entry points: `main.fish`, or first non-test script
- Binary: `fish` (override with `FISH` env or `fish_binary` config)

## License

Apache License 2.0.
