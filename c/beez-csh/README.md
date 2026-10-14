# csh

Official tcsh/csh compiler plugin — `tcsh -n` / `csh -n` syntax check with auto-detected `*.csh` targets.

Plugin ID: **`coditary/csh`**

## Install

```lua
reqpack { beez = { { name = "coditary/csh", version = "1.0.0", source = "github:Coditary/beez-csh" } } }
```

## Usage

```lua
configure({ { "coditary/csh", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[csh]
beez -s coditary/csh:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `tcsh` or `csh` | Creates `build/csh/.csh-setup` |
| compile | `tcsh -n` / `csh -n` | Syntax-checks all non-test `*.csh` |
| bundle | verify compile stamp | Checks `build/csh/.csh-compile-*` |
| test | run primary script | Executes `main.csh` or first entry |

## Detection

- Markers: `**/*.csh`
- Entry points: `main.csh` or first non-test `*.csh`
- Binary: `tcsh` preferred, falls back to `csh`

## License

Apache License 2.0.
