# batch

Official Windows batch plugin — validate `.bat`/`.cmd` scripts via Wine `cmd.exe` or DOSBox on Linux/macOS.

Plugin ID: **`coditary/batch`**

## Requirements

**Wine or DOSBox is required.** Windows batch files are not native on Unix; this plugin validates scripts through one of two backends:

### Wine backend (default)

1. Install [Wine](https://www.winehq.org/) (e.g. `dnf install wine` on Fedora).
2. Wine provides `cmd.exe` for running batch scripts.

### DOSBox backend

1. Install [DOSBox](https://www.dosbox.com/) (e.g. `dnf install dosbox`).
2. Set `batch_backend = "dosbox"` in `configure()` or export `BATCH_BACKEND=dosbox`.

Optional environment variables:

| Variable | Default | Purpose |
|----------|---------|---------|
| `WINE` | `wine` | Wine launcher binary |
| `WINEPREFIX` | `~/.wine` | Wine prefix directory |
| `CMD_BINARY` | `cmd.exe` | Windows command interpreter under Wine |
| `DOSBOX_BINARY` | `dosbox` | DOSBox binary for legacy batch |
| `BATCH_BACKEND` | `wine` | Backend: `wine` or `dosbox` |

## Install

```lua
reqpack { beez = { { name = "coditary/batch", version = "1.0.0", source = "github:Coditary/beez-batch" } } }
```

## Usage

```lua
configure({ { "coditary/batch", {} } })

-- Or with DOSBox backend:
configure({ { "coditary/batch", { batch_backend = "dosbox" } } })
```

```bash
beez -p compile[batch]
beez -s batch:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `batch` | `wine cmd.exe /c ver` or `dosbox -version` | Verifies backend |
| compile | `batch` | `wine cmd.exe /c call script.bat` | Validates all `.bat`/`.cmd` files |
| bundle | `batch` | verify compile stamp | Checks `build/batch/bin/.batch-compile-*` |
| test | `batch` | run entry script | Writes `report/test/batch-*.ok` |

## Detection

- Markers: `**/*.bat`, `**/*.cmd`
- Entry point: `main.bat`, `run.bat`, or first non-test source file
- Compile targets: all non-test `.bat` and `.cmd` files via `ctx.glob`

## License

Apache License 2.0.
