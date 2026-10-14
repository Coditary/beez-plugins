# crystal

Official Crystal compiler — `crystal build` with auto-detected targets (LLVM native code).

Plugin ID: **`coditary/crystal`**

## Install

```lua
reqpack { beez = { { name = "coditary/crystal", version = "1.0.0", source = "github:Coditary/beez-crystal" } } }
```

## Usage

```lua
configure({ { "coditary/crystal", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `shards install` | Skipped when no `shard.yml` manifest |
| compile | `crystal build --release` | Output under `build/crystal/bin/` |
| bundle | verify binaries | Checks `build/crystal/bin/**` |
| test | `crystal spec` | Runs all spec files |

## Detection

- Markers: `shard.yml`, `**/*.cr`
- Entry points: `src/<package>.cr`, `src/main.cr`, or first non-spec `src/*.cr`

## License

Apache License 2.0.
