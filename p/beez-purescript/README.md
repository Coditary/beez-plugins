# purescript

Official PureScript compiler — `spago build` or `purs compile` with auto-detected project layout.

Plugin ID: **`coditary/purescript`**

## Install

```lua
reqpack { beez = { { name = "coditary/purescript", version = "1.0.0", source = "github:Coditary/beez-purescript" } } }
```

## Usage

```lua
configure({ { "coditary/purescript", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `spago install` or `npm install` | Prefers spago when `spago.yaml`/`spago.dhall` exists |
| compile | `spago build` or `purs compile` | Fallback compiles all `src/**/*.purs` |
| bundle | verify output | Checks compiled JS under `build/purescript/output/` |
| test | `spago test` | Skipped when no spago manifest is present |

## Detection

- Markers: `spago.yaml`, `spago.dhall`, `package.json`, `**/*.purs`

## License

Apache License 2.0.
