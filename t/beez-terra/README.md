# terra

Official Terra compiler — LLVM embedded in Lua with auto-detected `.t` and `.lua` targets.

Plugin ID: **`coditary/terra`**

## Install

```lua
reqpack { beez = { { name = "coditary/terra", version = "1.0.0", source = "github:Coditary/beez-terra" } } }
```

## Usage

```lua
configure({ { "coditary/terra", {} } })
```

```bash
beez -p compile[terra]
beez -s terra:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `terra` | `terra -v` | Verifies Terra compiler binary |
| compile | `terra` | `terra -O2 script.t` | JIT compile via terra |
| compile (debug) | `terra` | `terra -g script.t` | Debug info enabled |
| bundle | `terra` | verify compile stamp | Checks `build/terra/*.ok` |
| test | `terra` | `terra entry.t` | Runs primary or test target |

## Detection

- Markers: `**/*.t`, `**/*.lua`
- Entry points: `main.t`, `src/main.t`, `main.lua`, or first root `*.t`
- Tests: `tests/**/*.t`, `test/**/*.t`, supporting `.lua` test files

## License

Apache License 2.0.
