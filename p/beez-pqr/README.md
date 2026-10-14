# pqr

pqR (parallel quick R) — faster R implementation with `R CMD INSTALL`, byte-compiled scripts, and testthat.

Plugin ID: **`coditary/pqr`**

## Install

```lua
reqpack { beez = { { name = "coditary/pqr", version = "1.0.0", source = "github:Coditary/beez-pqr" } } }
```

## Usage

```lua
configure({ { "coditary/pqr", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[pqr]
beez -s pqr:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `remotes::install_deps()` | Installs DESCRIPTION dependencies into `build/pqr/lib/` |
| compile | `pqR CMD INSTALL` / `compile()` | Packages to `build/pqr/lib/`; scripts to `build/pqr/*.Rc` |
| bundle | verify artifacts | Checks `build/pqr/**` |
| test | `testthat::test_dir()` | Runs `tests/testthat/` via pqR/R |

## Detection

- Markers: `DESCRIPTION`, `**/*.R`
- Packages: `DESCRIPTION` at project root → `R CMD INSTALL --library=build/pqr/lib`
- Scripts: `main.R`, `R/main.R`, or first non-test `*.R`
- Binary: `pqR` with fallback to `R` (override with `PQR` / `R` env or config)

## License

Apache License 2.0.
