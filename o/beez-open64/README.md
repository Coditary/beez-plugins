# open64

**Open64** Fortran/C compiler suite (historical) — `openf90` / `opencc` with auto-detected targets.

> **Legacy status:** Open64 is a discontinued compiler lineage (SGI/MIPSpro → PathScale → AMD). It is preserved here for historical Fortran/C builds and toolchain archaeology. For active development, prefer modern compilers such as `coditary/gfortran`, `coditary/flang`, or `coditary/gcc`.

Plugin ID: **`coditary/open64`**

## Install

```lua
reqpack { beez = { { name = "coditary/open64", version = "1.0.0", source = "github:Coditary/beez-open64" } } }
```

## Usage

```lua
configure({ { "coditary/open64", {} } })
workflows({ build = "coditary/open64:build" })
```

```bash
beez build
beez -p compile[open64]
beez -s open64:compile
```

## Detection

| Marker | Purpose |
|--------|---------|
| `**/*.f` | Fixed-form Fortran sources |
| `**/*.f90` | Free-form Fortran 90 sources |
| `**/*.f95` | Fortran 95 sources |
| `**/*.c` | C sources |
| `CMakeLists.txt` | CMake-based projects |
| `Makefile` | Makefile-based projects |

Build targets are resolved from `main.f90`, `main.c`, `program.f90`, `src/main.*`, `cmd/*/main.*`, or all non-test sources. Fortran targets use `openf90`; C targets use `opencc`. Output goes to `build/open64/bin/`.

Test programs are detected from `tests/**`, `test/**`, `*test*`, and `*_test` patterns.

## Requirements

- `openf90` on `PATH` (Open64 Fortran compiler)
- `opencc` on `PATH` (Open64 C compiler)

## License

Apache License 2.0.
