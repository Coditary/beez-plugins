# flang

LLVM **Flang** Fortran compiler — CMake, Makefile, or direct `*.f` / `*.f90` / `*.f95` compilation with auto-detected targets.

Plugin ID: **`coditary/flang`**

## Install

```lua
reqpack { beez = { { name = "coditary/flang", version = "1.0.0", source = "github:Coditary/beez-flang" } } }
```

## Usage

```lua
configure({ { "coditary/flang", {} } })
```

```bash
beez -p setup[flang]
beez -p compile[flang]
beez -p bundle[flang]
beez -p test[flang]
```

Build artifacts are written to `build/flang/bin/`.

## Detection

| Marker | Role |
|--------|------|
| `CMakeLists.txt` | CMake project (uses `CMAKE_Fortran_COMPILER`) |
| `Makefile` | Make project (`FC` / `F77` set to Flang) |
| `*.f90`, `*.f95`, `*.f` | Direct single-file compilation |

The compiler binary is resolved as `flang-new` with fallback to `flang`.

Release builds use `-O2`; debug builds use `-g`.

## License

Apache License 2.0.
