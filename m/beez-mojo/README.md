# mojo

Official Mojo compiler — `mojo build` with auto-detected targets (Python-compatible, LLVM AOT for HPC/AI).

Plugin ID: **`coditary/mojo`**

## Install

```lua
reqpack { beez = { { name = "coditary/mojo", version = "1.0.0", source = "github:Coditary/beez-mojo" } } }
```

## Usage

```lua
configure({ { "coditary/mojo", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[mojo]
beez -s mojo:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `magic install` | Skipped when no `mojoproject.toml` manifest |
| compile | `mojo build -O3` | Output under `build/mojo/bin/` |
| bundle | verify binaries | Checks `build/mojo/bin/**` |
| test | `mojo test -I ./src` | Writes `report/test/mojo-<profile>.ok` |

## Detection

- Markers: `mojoproject.toml`, `**/*.mojo`, `**/*.🔥`
- Entry points: `src/main.mojo`, `src/<package>.mojo`, or first `src/*.mojo`

## License

Apache License 2.0.
