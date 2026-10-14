# flix

Flix functional language compiler to JVM bytecode.

Plugin ID: **`coditary/flix`**

## Install

```lua
reqpack { beez = { { name = "coditary/flix", version = "1.0.0", source = "github:Coditary/beez-flix" } } }
```

## Usage

```lua
configure({ { "coditary/flix", {} } })
workflows({ build = "coditary/flix:build" })
```

```bash
beez -p compile[flix]
beez -s flix:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `flix` | Verify `flix` binary, prepare `build/flix/` |
| compile | `flix` | Build Flix project with flix build |
| bundle | `flix` | Verify Flix build artifacts |
| test | `flix` | Run Flix tests with flix test |

## Detection

- Markers: **/*.flix
- Binary: `flix` (override with `FLIX` env or `flix_binary` config)

## License

Apache License 2.0.
