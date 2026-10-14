# lfortran

**LFortran** — interactive LLVM-based Fortran compiler with auto-detected targets.

Plugin ID: **`coditary/lfortran`**

## Install

```lua
reqpack { beez = { { name = "coditary/lfortran", version = "1.0.0", source = "github:Coditary/beez-lfortran" } } }
```

## Usage

```lua
configure({ { "coditary/lfortran", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[lfortran]
beez -s lfortran:compile
```

## Detection

| Marker | Purpose |
|--------|---------|
| `**/*.f` | Fixed-form Fortran sources |
| `**/*.f90` | Free-form Fortran sources |
| `**/*.f95` | Fortran 95 sources |

Entry points are resolved from `program.f90`, `main.f90`, `src/main.f90`, or the first non-test source file. Binaries are written to `build/lfortran/bin/`.

## License

Apache License 2.0.
