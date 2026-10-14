# cxxr

> **Experimental / historical:** [CXXR](https://github.com/johnmuller89/CXXR) was a research project to reimplement the R interpreter in C++. Development stalled and the codebase is incomplete — use only for experimentation or historical interest. Prefer `coditary/r` for production R package builds.

CXXR R package compiler plugin — `R CMD build` / `R CMD check` via the CXXR binary (with `R` fallback).

Plugin ID: **`coditary/cxxr`**

## Install

```lua
reqpack { beez = { { name = "coditary/cxxr", version = "1.0.0", source = "github:Coditary/beez-cxxr" } } }
```

## Usage

```lua
configure({ { "coditary/cxxr", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[cxxr]
beez -s cxxr:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `cxxr CMD INSTALL deps` | Skipped when no DESCRIPTION |
| compile | `cxxr CMD build --output=build/cxxr` | Output under `build/cxxr/` |
| bundle | verify tarball | Checks `build/cxxr/**/*.tar.gz` |
| test | `cxxr CMD check .` | Writes `report/test/cxxr-*.ok` |

## Detection

- Markers: `DESCRIPTION`, `**/*.R`
- Entry points: `R/<pkg>.R`, `R/main.R`, or first non-test `*.R`
- Binary: `cxxr` with fallback to `R` (override with `CXXR` / `R` env or config)

## License

Apache License 2.0.
