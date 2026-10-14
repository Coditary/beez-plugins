# swiftforth

Official SwiftForth compiler plugin — SwiftForth with auto-detected source targets.

Plugin ID: **`coditary/swiftforth`**

## Install

```lua
reqpack { beez = { { name = "coditary/swiftforth", version = "1.0.0", source = "github:Coditary/beez-swiftforth" } } }
```

## Usage

```lua
configure({ { "coditary/swiftforth", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[swiftforth]
beez -s swiftforth:compile
```

## Steps

| Phase | Tool | Notes |
|-------|------|-------|
| setup | `swiftforth` | Verify compiler and prepare `build/swiftforth/` |
| compile | `swiftforth` | Compile via `swiftforth -nt -i <source>`. |
| bundle | verify artifacts | Checks outputs under `build/swiftforth/` |
| test | `prove -l t/` | Writes `report/test/swiftforth-*.ok` |

## Detection

- Markers: `**/*.fs`, `**/*.fth`, `**/*.4th`
- Scope: `swiftforth`
- Binary: `swiftforth` (override with `SWIFTFORTH` env or `swiftforth_binary` config)

## License

Apache License 2.0.
