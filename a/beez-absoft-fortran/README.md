# absoft-fortran

**Absoft Pro Fortran** — commercial HPC Fortran compiler with auto-detected sources and release (`-O3`) builds.

Plugin ID: **`coditary/absoft-fortran`**

> **License requirement:** Absoft Pro Fortran is **commercial software**. A valid Absoft license must be installed and activated on the build machine before using this plugin. See [Absoft Pro Fortran](https://www.absoft.com/fortran-compiler/) for licensing details.

## Install

```lua
reqpack { beez = { { name = "coditary/absoft-fortran", version = "1.0.0", source = "github:Coditary/beez-absoft-fortran" } } }
```

Local development:

```lua
reqpack { beez = { { name = "coditary/absoft-fortran", path = ".", version = "1.0.0" } } }
```

## Usage

```lua
configure({ { "coditary/absoft-fortran", {} } })
workflows({ build = "coditary/absoft-fortran:build" })
```

```bash
beez build
beez -p compile[absoft]
beez -s absoft-fortran:compile
```

## Detection

| Marker | Purpose |
|--------|---------|
| `**/*.f` | Fixed-form Fortran sources (compiled with `f77`) |
| `**/*.f90` | Free-form Fortran 90 sources (compiled with `f90`) |
| `CMakeLists.txt` | CMake-based Fortran projects |
| `Makefile` | Makefile-based Fortran projects |

Build targets are resolved from `main.f90`, `program.f90`, `src/main.f90`, `cmd/*/main.f90`, or all non-test sources. Output goes to `build/absoft/bin/`.

Test programs are detected from `tests/**`, `test/**`, `*test*`, and `*_test` patterns.

## Requirements

- `f90` and `f77` on `PATH` (Absoft Pro Fortran)

## Configuration

```lua
configure({
  { "coditary/absoft-fortran", {
      f90_binary = "f90",
      f77_binary = "f77",
      absoft_flags = {},
  }},
})
```

Set `ABSOFT_PARALLEL` to control parallel CMake build jobs.

## Plugin license

Apache License 2.0 (this Beez plugin only — not Absoft Pro Fortran itself).
