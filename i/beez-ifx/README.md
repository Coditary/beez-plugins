# ifx

Intel Fortran compiler (**ifx** / **ifort**) — LLVM-based ifx with ifort fallback.

Plugin ID: **`coditary/ifx`**

## Install

```lua
reqpack { beez = { { name = "coditary/ifx", version = "1.0.0", source = "github:Coditary/beez-ifx" } } }
```

## Usage

```lua
configure({ { "coditary/ifx", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[ifx]
beez -s coditary/ifx:compile:code
```

## Detection

The plugin auto-detects Fortran projects via:

- `CMakeLists.txt`
- `Makefile`
- `**/*.f`, `**/*.f90`, `**/*.f95`

Binaries are written to `build/ifx/bin/`. Release builds use `-O3`.

## Compiler selection

Uses `ifx` when available, otherwise falls back to `ifort`.

## License

Apache License 2.0.
