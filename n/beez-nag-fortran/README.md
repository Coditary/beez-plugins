# nag-fortran

NAG Fortran Compiler (**nagfor**) — commercial, strict ISO Fortran with auto-detected targets.

Plugin ID: **`coditary/nag-fortran`**

> **License requirement:** The NAG Fortran Compiler is **commercial software**. A valid NAG license (node-locked or floating) must be installed and activated on the build machine before using this plugin. See [NAG Fortran Compiler](https://www.nag.com/nagfor) for licensing details.

## Install

```lua
reqpack { beez = { { name = "coditary/nag-fortran", version = "1.0.0", source = "github:Coditary/beez-nag-fortran" } } }
```

Local development:

```lua
reqpack { beez = { { name = "coditary/nag-fortran", path = ".", version = "1.0.0" } } }
```

## Usage

```lua
configure({ { "coditary/nag-fortran", {} } })
```

```bash
beez -p setup[nag]
beez -p compile[nag]
beez -p bundle[nag]
beez -p test[test]
```

Build artifacts are written to `build/nag/bin/`.

## Detection

| Marker | Role |
|--------|------|
| `CMakeLists.txt` | CMake project (uses `-DCMAKE_Fortran_COMPILER=nagfor`) |
| `Makefile` | GNU Make project (uses `FC=nagfor`) |
| `*.f` / `*.f90` / `*.f95` | Direct source compilation |

Release builds use `-f2008 -O3` (strict ISO Fortran 2008). Debug builds use `-f2008 -g -O0`.

## Configuration

```lua
configure({
  { "coditary/nag-fortran", {
      nagfor_binary = "nagfor",
      fortran_std = "-f2008",
      optimize = "-O3",
  }},
})
```

Set `NAG_PARALLEL` to control parallel make/cmake build jobs.

## Plugin license

Apache License 2.0 (this Beez plugin only — not the NAG Fortran Compiler itself).
