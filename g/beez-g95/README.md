# g95

**G95 Fortran compiler** — historical Fortran 95 compiler with auto-detected `.f` / `.f90` / `.f95` sources.

Plugin ID: **`coditary/g95`**

> **Legacy notice:** G95 is a discontinued, historical Fortran 95 compiler. Development
> effectively stopped in the late 2000s. Modern Fortran projects should prefer
> [GNU Fortran (gfortran)](https://gcc.gnu.org/fortran/) or [Intel Fortran (ifx)](https://www.intel.com/content/www/us/en/developer/tools/oneapi/fortran-compiler.html).
> This plugin exists for maintaining legacy codebases and historical builds only.

## Install

```lua
reqpack { beez = { { name = "coditary/g95", version = "1.0.0", source = "github:Coditary/beez-g95" } } }
```

## Usage

```lua
configure({ { "coditary/g95", {} } })
workflows({ build = "coditary/g95:build" })
```

```bash
beez build
beez -p compile[g95]
beez -s g95:compile
```

## Detection

| Marker | Purpose |
|--------|---------|
| `**/*.f` | Fixed-form Fortran source |
| `**/*.f90` | Free-form Fortran 90 source |
| `**/*.f95` | Fortran 95 source |

Build targets are resolved from `main.f90`, `program.f90`, `src/main.f90`, `cmd/*/main.f90`, or all non-test sources. Output goes to `build/g95/bin/`.

Test programs are detected from `tests/**`, `*test*`, and `*_test` patterns.

## Requirements

- `g95` on `PATH` (G95 Fortran compiler)

## License

Apache License 2.0.
