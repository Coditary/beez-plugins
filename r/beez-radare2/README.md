# radare2

Official Radare2 plugin — binary reverse engineering with r2 auto-analysis.

Plugin ID: **`coditary/radare2`**

## Install

```lua
reqpack { beez = { { name = "coditary/radare2", version = "1.0.0", source = "github:Coditary/beez-radare2" } } }
```

## Usage

```lua
configure({ { "coditary/radare2", {} } })
```

```bash
beez -p compile[radare2]
beez -s radare2:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `radare2` | `r2 -v` | Verifies radare2 CLI |
| compile | `radare2` | `r2 -A -q -c 'aaa; ...'` | Auto-analysis on binary |
| bundle | `radare2` | verify report | Checks analysis report |
| test | `radare2` | verify output | Validates analysis artifacts |

## Detection

- Markers: `**/*` (binaries, shared objects, executables)
- Entry point: first likely binary, or `entry_source` in configure()

## License

Apache License 2.0.
