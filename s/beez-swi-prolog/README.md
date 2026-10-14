# swi-prolog

Official SWI-Prolog compiler plugin — compile .pl sources with swipl -c, auto-detected **/*.pl.

Plugin ID: **`coditary/swi-prolog`**

## Install

```lua
reqpack { beez = { { name = "coditary/swi-prolog", version = "1.0.0", source = "github:Coditary/beez-swi-prolog" } } }
```

## Usage

```lua
configure({ { "coditary/swi-prolog", {} } })
workflows({ build = "coditary/swi-prolog:build" })
```

```bash
beez build
beez -p compile[swi-prolog]
beez -s swi-prolog:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `swi-prolog` | Verify `swipl` toolchain |
| compile | `swi-prolog` | Compile detected sources |
| bundle | `swi-prolog` | Verify build artifacts under `build/swi-prolog/bin/` |
| test | `swi-prolog` | Run primary output or write test stamp |

## Detection

- Markers: `**/*.pl`
- Compile targets: auto-detected entry points via `ctx.glob`
- Binary: `swipl` (override with `SWIPL` env or `swipl_binary` config)

## License

Apache License 2.0.
