# dylan

Official Open Dylan compiler plugin — `dylan-compiler` with auto-detected `.dylan` and `.lid` targets.

Plugin ID: **`coditary/dylan`**

## Install

```lua
reqpack { beez = { { name = "coditary/dylan", version = "1.0.0", source = "github:Coditary/beez-dylan" } } }
```

## Usage

```lua
configure({ { "coditary/dylan", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[dylan]
beez -s dylan:compile
```

## Steps

| Phase | Tool | Notes |
|-------|------|-------|
| setup | `dylan-compiler` | Verify compiler and prepare `build/dylan/` |
| compile | `dylan-compiler -build` | Builds from `.lid` manifest into `_build/bin/` |
| bundle | verify artifacts | Checks executables under `_build/bin/` |
| test | `dylan-compiler -build -test` | Writes `report/test/dylan-*.ok` |

## Detection

- Markers: `**/*.dylan`, `**/*.lid`
- Scope: `dylan`
- Binary: `dylan-compiler` (override with `DYLAN_COMPILER` env or `dylan_binary` config)

## License

Apache License 2.0.
