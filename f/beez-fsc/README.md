# fsc

Official F# compiler plugin — fsc with auto-detected source targets.

Plugin ID: **`coditary/fsc`**

## Install

```lua
reqpack { beez = { { name = "coditary/fsc", version = "1.0.0", source = "github:Coditary/beez-fsc" } } }
```

## Usage

```lua
configure({ { "coditary/fsc", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[fsharp]
beez -s fsc:compile
```

## Steps

| Phase | Tool | Notes |
|-------|------|-------|
| setup | `fsc` | Verify compiler and prepare `build/fsc/` |
| compile | `fsc` | Compile via `fsc` (standalone `.fs`) or `dotnet build` (`.fsproj`). |
| bundle | verify artifacts | Checks outputs under `build/fsc/` |
| test | `prove -l t/` | Writes `report/test/fsc-*.ok` |

## Detection

- Markers: `**/*.fs`, `*.fsproj`, `**/*.fsproj`
- Scope: `fsharp`
- Binary: `fsc` (override with `FSC` env or `fsc_binary` config)

## License

Apache License 2.0.
