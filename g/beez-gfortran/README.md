# gfortran

**GNU Fortran (gfortran)** — auto-detected Fortran sources with release (`-O3`) builds.

Plugin ID: **`coditary/gfortran`**

## Install

```lua
reqpack { beez = { { name = "coditary/gfortran", version = "1.0.0", source = "github:Coditary/beez-gfortran" } } }
```

## Usage

```lua
configure({ { "coditary/gfortran", {} } })
workflows({ build = "coditary/gfortran:build" })
```

```bash
beez build
beez -p compile[gfortran]
beez -s gfortran:compile
```

## Detection

| Marker | Purpose |
|--------|---------|
| `**/*.f` | Fixed-form Fortran sources |
| `**/*.f90` | Free-form Fortran 90 sources |
| `**/*.f95` | Fortran 95 sources |
| `CMakeLists.txt` | CMake-based Fortran projects |
| `Makefile` | Makefile-based Fortran projects |

Build targets are resolved from `main.f90`, `program.f90`, `src/main.f90`, `cmd/*/main.f90`, or all non-test sources. Output goes to `build/gfortran/bin/`.

Test programs are detected from `tests/**`, `test/**`, `*test*`, and `*_test` patterns.

## Requirements

- `gfortran` on `PATH` (GNU Fortran Compiler)

## License

Apache License 2.0.
