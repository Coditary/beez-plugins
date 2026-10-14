# fstar

F* theorem prover — verify and cache-check .fst modules.

Plugin ID: **`coditary/fstar`**

## Install

```lua
reqpack { beez = { { name = "coditary/fstar", version = "1.0.0", source = "github:Coditary/beez-fstar" } } }
```

## Usage

```lua
configure({ { "coditary/fstar", {} } })
workflows({ build = "coditary/fstar:build" })
```

```bash
beez -p compile[fstar]
beez -s fstar:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `fstar` | Verify `fstar` binary, prepare `build/fstar/` |
| compile | `fstar` | Verify F* .fst modules with fstar --cache_checked_modules |
| bundle | `fstar` | Verify F* checked module artifacts |
| test | `fstar` | Run F* tests in t/ with prove |

## Detection

- Markers: **/*.fst
- Binary: `fstar` (override with `FSTAR` env or `fstar_binary` config)

## License

Apache License 2.0.
