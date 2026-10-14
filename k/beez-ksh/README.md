# ksh

Official KornShell compiler plugin — `ksh -n` syntax check with auto-detected `*.ksh` targets.

Plugin ID: **`coditary/ksh`**

## Install

```lua
reqpack { beez = { { name = "coditary/ksh", version = "1.0.0", source = "github:Coditary/beez-ksh" } } }
```

## Usage

```lua
configure({ { "coditary/ksh", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[ksh]
beez -s coditary/ksh:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `ksh` | Creates `build/ksh/.ksh-setup` |
| compile | `ksh -n` | Syntax-checks all non-test scripts |
| bundle | verify compile stamp | Checks `build/ksh/.ksh-compile-*` |
| test | run primary script | Executes `main.ksh` or first entry |

## Detection

- Markers: `**/*.ksh`
- Entry points: `main.ksh`, or first non-test script
- Binary: `ksh` (override with `KSH` env or `ksh_binary` config)

## License

Apache License 2.0.
