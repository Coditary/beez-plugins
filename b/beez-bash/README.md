# bash

Official Bash compiler plugin — `bash -n` syntax check with auto-detected `*.sh`/`*.bash` targets.

Plugin ID: **`coditary/bash`**

## Install

```lua
reqpack { beez = { { name = "coditary/bash", version = "1.0.0", source = "github:Coditary/beez-bash" } } }
```

## Usage

```lua
configure({ { "coditary/bash", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[bash]
beez -s coditary/bash:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `bash` | Creates `build/bash/.bash-setup` |
| compile | `bash -n` | Syntax-checks all non-test scripts |
| bundle | verify compile stamp | Checks `build/bash/.bash-compile-*` |
| test | run primary script | Executes `main.sh` or first entry |

## Detection

- Markers: `**/*.sh`, `**/*.bash`
- Entry points: `main.sh`, `main.bash`, or first non-test script
- Binary: `bash` (override with `BASH` env or `bash_binary` config)

## License

Apache License 2.0.
