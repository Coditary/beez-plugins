# fantom

Fantom JVM/CLR compiler — fan build from .fan sources.

Plugin ID: **`coditary/fantom`**

## Install

```lua
reqpack { beez = { { name = "coditary/fantom", version = "1.0.0", source = "github:Coditary/beez-fantom" } } }
```

## Usage

```lua
configure({ { "coditary/fantom", {} } })
workflows({ build = "coditary/fantom:build" })
```

```bash
beez -p compile[fantom]
beez -s fantom:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `fantom` | Verify `fan` binary, prepare `build/fantom/` |
| compile | `fantom` | Build Fantom project with fan build |
| bundle | `fantom` | Verify Fantom build artifacts |
| test | `fantom` | Run Fantom tests with fan test |

## Detection

- Markers: build.fan, **/build.fan, **/*.fan
- Binary: `fan` (override with `FAN` env or `fan_binary` config)

## License

Apache License 2.0.
