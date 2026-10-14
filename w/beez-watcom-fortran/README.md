# watcom-fortran

**Watcom Fortran (wfc / wfl)** — historical DOS/x86 Fortran compiler with auto-detected sources and release (`-ot`) builds.

> **Historical status:** Watcom Fortran was widely used on DOS, OS/2, and early Windows x86 systems. The toolchain is maintained today primarily as [Open Watcom](https://openwatcom.org/) for legacy and retro-computing projects. This plugin targets cross-build or emulator workflows — not modern production Fortran.

Plugin ID: **`coditary/watcom-fortran`**

## Install

```lua
reqpack { beez = { { name = "coditary/watcom-fortran", version = "1.0.0", source = "github:Coditary/beez-watcom-fortran" } } }
```

## Usage

```lua
configure({ { "coditary/watcom-fortran", {} } })
workflows({ build = "coditary/watcom-fortran:build" })
```

```bash
beez build
beez -p compile[watcom]
beez -s watcom-fortran:compile
```

## Detection

| Marker | Purpose |
|--------|---------|
| `**/*.f` | Fixed-form Fortran sources |
| `**/*.for` | Watcom/DOS-style Fortran sources |
| `**/*.f90` | Free-form Fortran 90 sources |
| `CMakeLists.txt` | CMake-based Fortran projects |
| `Makefile` | Makefile-based Fortran projects |

Build targets are resolved from `main.for`, `main.f90`, `program.for`, `src/main.f`, `cmd/*/main.for`, or all non-test sources. Output goes to `build/watcom/bin/` (`.exe` suffix).

Test programs are detected from `tests/**`, `test/**`, `*test*`, and `*_test` patterns. Set `WATCOM_RUN` (e.g. `dosbox`) to execute tests under an emulator.

## Requirements

- `wfc` and `wfl` on `PATH` (Open Watcom Fortran or legacy Watcom toolchain)
- For running DOS binaries on Linux/macOS, configure `WATCOM_RUN` with an emulator such as DOSBox

## License

Apache License 2.0.
