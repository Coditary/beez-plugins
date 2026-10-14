# hack

Official Hack compiler plugin — hhc with auto-detected source targets.

Plugin ID: **`coditary/hack`**

## Install

```lua
reqpack { beez = { { name = "coditary/hack", version = "1.0.0", source = "github:Coditary/beez-hack" } } }
```

## Usage

```lua
configure({ { "coditary/hack", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[hack]
beez -s hack:compile
```

## Steps

| Phase | Tool | Notes |
|-------|------|-------|
| setup | `hhc` | Verify compiler and prepare `build/hack/` |
| compile | `hhc` | Type-check via `hhc` (project-wide when `.hhconfig` is present). |
| bundle | verify artifacts | Checks outputs under `build/hack/` |
| test | `prove -l t/` | Writes `report/test/hack-*.ok` |

## Detection

- Markers: `**/*.hack`, `.hhconfig`, `**/.hhconfig`
- Scope: `hack`
- Binary: `hhc` (override with `HHC` env or `hack_binary` config)

## License

Apache License 2.0.
