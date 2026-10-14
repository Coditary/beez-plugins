# f2c

**f2c Fortran-to-C transpiler** — auto-detected `.f`/`.for` sources transpiled with f2c and compiled with gcc.

Plugin ID: **`coditary/f2c`**

## Install

```lua
reqpack { beez = { { name = "coditary/f2c", version = "1.0.0", source = "github:Coditary/beez-f2c" } } }
```

## Usage

```lua
configure({ { "coditary/f2c", {} } })
workflows({ build = "coditary/f2c:build" })
```

```bash
beez build
beez -p compile[f2c]
beez -s f2c:compile
```

## Detection

| Marker | Purpose |
|--------|---------|
| `**/*.f` | Fixed-form Fortran 77 sources |
| `**/*.for` | Alternate Fortran source extension |
| `CMakeLists.txt` | CMake-based projects (f2c + gcc) |
| `Makefile` | Makefile-based projects (f2c + gcc) |

Build targets are resolved from `main.f`, `program.f`, `src/main.f`, `cmd/*/main.f`, or all non-test sources. Generated C files go to `build/f2c/gen/`, binaries to `build/f2c/bin/`.

Test programs are detected from `tests/**`, `test/**`, `*test*`, and `*_test` patterns.

## Requirements

- `f2c` on `PATH` (Fortran-to-C transpiler)
- `gcc` on `PATH` (C compiler, links with `-lf2c -lm`)

## License

Apache License 2.0.
