# vbc

Visual Basic .NET — vbc/dotnet for .vb and .vbproj projects.

Plugin ID: **`coditary/vbc`**

## Install

```lua
reqpack { beez = { { name = "coditary/vbc", version = "1.0.0", source = "github:Coditary/beez-vbc" } } }
```

## Usage

```lua
configure({ { "coditary/vbc", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[vbc]
beez -s vbc:compile
```

## Steps

| Phase | Step | Notes |
|-------|------|-------|
| setup | `configure:setup` / `configure:debug` | Toolchain verification |
| compile | `compile:code` / `compile:debug` | Compile Visual Basic with vbc/dotnet |
| bundle | `bundle:code` / `bundle:debug` | Verify build artifacts |
| test | `test:unit` / `test:debug` | Writes `report/test/vbc-*.ok` |

## Detection

- Markers: *.vbproj, **/*.vbproj, **/*.vb
- Entry points: `main.vb`, `src/main.vb`, or first non-test source file
- Uses `dotnet build` for `.vbproj` or `vbc /out:` for standalone `.vb` files.

## License

Apache License 2.0.
