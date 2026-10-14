# turbopascal

**Borland Turbo Pascal** — historical DOS compiler with auto-detected `.pas` / `.p` sources.

Plugin ID: **`coditary/turbopascal`**

> **Legacy notice:** Turbo Pascal (TP 5.x–7.x) is a discontinued, historical DOS compiler
> from Borland (1980s–1990s). It produces 16-bit DOS executables and requires a DOS
> environment or emulator to run. Modern Pascal projects should prefer
> [Free Pascal (FPC)](https://www.freepascal.org/) or [Delphi](https://www.embarcadero.com/products/delphi).
> This plugin exists for maintaining legacy codebases, retro computing, and historical builds only.

## Install

```lua
reqpack { beez = { { name = "coditary/turbopascal", version = "1.0.0", source = "github:Coditary/beez-turbopascal" } } }
```

## Usage

```lua
configure({ { "coditary/turbopascal", {} } })
workflows({ build = "coditary/turbopascal:build" })
```

```bash
beez build
beez -p compile[turbopascal]
beez -s turbopascal:compile
```

## Detection

| Marker | Purpose |
|--------|---------|
| `**/*.pas` | Pascal source files |
| `**/*.p` | Alternate Pascal extension |

Build targets are resolved from `main.pas`, `program.pas`, `src/main.pas`, `cmd/*/main.pas`, or all non-test sources. Output goes to `build/turbopascal/bin/` (`.exe` artifacts).

Test programs are detected from `tests/**`, `*test*`, and `*_test` patterns.

## Requirements

Turbo Pascal is a **DOS-native** toolchain. You need one of:

| Component | Role |
|-----------|------|
| **`tpc`** | Turbo Pascal Compiler (command-line; preferred) |
| **`turbo`** | Turbo Pascal IDE (interactive; not used by default) |
| **DOSBox / FreeDOS / DOSEMU** | Run `tpc` and produced `.exe` files on modern Linux/macOS/Windows |

Place a wrapper script named `tpc` on `PATH` that invokes the real compiler inside your DOS environment, for example:

```bash
#!/bin/sh
# ~/bin/tpc — example DOSBox wrapper
exec dosbox -silent -exit \
  -c "mount c ${TPC_ROOT:-/opt/turbopascal}" \
  -c "mount d $(pwd)" \
  -c "d:" \
  -c "c:\\tpc.exe $*"
```

For running test executables, set a host runner via `run_binary` in `configure()` or the `TPC_RUN` environment variable (e.g. a DOSBox wrapper that executes a `.exe`).

```lua
configure({ { "coditary/turbopascal", {
  tpc_binary = "tpc",
  run_binary = "dosbox-run",
} } })
```

## Compiler flags

Default compile invocation uses `tpc /m` (make) with `/E` (EXE directory) and `/O` (object directory) pointing at `build/turbopascal/`. Override with `tpc_args` in `configure()`.

## Other Pascal compilers

| Plugin | Compiler | Use case |
|--------|----------|----------|
| `coditary/turbopascal` | **Turbo Pascal** | Legacy DOS (this plugin) |
| `coditary/gpc` | **GNU Pascal** | Historical Unix Pascal |
| `coditary/fpc` | **Free Pascal** | Modern cross-platform Pascal |

Load only the compiler plugin you need.

## License

Apache License 2.0.
