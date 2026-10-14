# vale

Official Vale compiler — valec LLVM codegen with generational references, auto-detected `*.vale` sources.

Plugin ID: **`coditary/vale`**

## Install

```lua
reqpack { beez = { { name = "coditary/vale", version = "1.0.0", source = "github:Coditary/beez-vale" } } }
```

## Usage

```lua
configure({ { "coditary/vale", {} } })
```

```bash
beez -p compile[vale]
beez -s vale:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `vale` | `valec --help` | Verifies Vale compiler binary |
| compile | `vale` | `valec build main=main.vale --output_dir build/vale/bin` | Native binary via LLVM |
| bundle | `vale` | verify binary | Checks `build/vale/bin/main` |
| test | `vale` | `valec test` | Skipped when no test files are detected |

## Detection

- Markers: `**/*.vale`
- Entry: `main.vale`, `src/main.vale`, first `*.vale`
- Module name derived from entry filename (default `main`)

## License

Apache License 2.0.
