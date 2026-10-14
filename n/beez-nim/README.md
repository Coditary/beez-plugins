# nim

Official Nim compiler — `nim c` with auto-detected targets (transpiles to C, links via GCC/Clang).

Plugin ID: **`coditary/nim`**

## Install

```lua
reqpack { beez = { { name = "coditary/nim", version = "1.0.0", source = "github:Coditary/beez-nim" } } }
```

## Usage

```lua
configure({ { "coditary/nim", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `nimble install -d` | Skipped when no `.nimble` manifest |
| compile | `nim c -d:release` | Output under `build/nim/bin/` |
| bundle | verify binaries | Checks `build/nim/bin/**` |
| test | `nim test` | Uses nimble test task when available |

## Detection

- Markers: `*.nimble`, `**/*.nim`
- Entry points: `src/<package>.nim`, `src/main.nim`, or first `src/*.nim`

## License

Apache License 2.0.
