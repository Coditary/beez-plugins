# r

GNU R compiler plugin — `R CMD build` / `R CMD check` with auto-detected R packages.

Plugin ID: **`coditary/r`**

## Install

```lua
reqpack { beez = { { name = "coditary/r", version = "1.0.0", source = "github:Coditary/beez-r" } } }
```

## Usage

```lua
configure({ { "coditary/r", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `R CMD INSTALL deps` | Skipped when no DESCRIPTION |
| compile | `R CMD build --output=build/r` | Output under `build/r/` |
| bundle | verify tarball | Checks `build/r/**/*.tar.gz` |
| test | `R CMD check .` | Writes `report/test/r-*.ok` |

## Detection

- Markers: `DESCRIPTION`, `**/*.R`
- Entry points: `R/<pkg>.R`, `R/main.R`, or first non-test `*.R`
- Binary: `R` (override with `R` env or `r_binary` config)

## License

Apache License 2.0.
