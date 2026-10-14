# myrddin

Official Myrddin compiler — mbld build system with 6m codegen, auto-detected `Myrddin.build`.

Plugin ID: **`coditary/myrddin`**

## Install

```lua
reqpack { beez = { { name = "coditary/myrddin", version = "1.0.0", source = "github:Coditary/beez-myrddin" } } }
```

## Usage

```lua
configure({ { "coditary/myrddin", {} } })
```

```bash
beez -p compile[myrddin]
beez -s myrddin:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `myrddin` | `mbld -h` | Verifies mbld build tool |
| compile | `myrddin` | `mbld -o build/myrddin/bin` | Full project build via Myrddin.build |
| bundle | `myrddin` | verify output dir | Checks build artifacts |
| test | `myrddin` | `mbld test` | Runs mbld test when build file present |

## Detection

- Markers: `Myrddin.build`, `bld.proj`, `**/*.myr`
- Fallback: `mbld -b app main.myr` for single-file projects

## License

Apache License 2.0.
