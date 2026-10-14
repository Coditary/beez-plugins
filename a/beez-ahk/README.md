# ahk

Official AutoHotkey plugin — syntax-check `.ahk` scripts via Wine on Linux/macOS.

Plugin ID: **`coditary/ahk`**

## Requirements

**Wine is required.** AutoHotkey is Windows-only; this plugin runs `AutoHotkeyU64.exe` and `Ahk2Exe.exe` under Wine.

1. Install [Wine](https://www.winehq.org/) (e.g. `dnf install wine` on Fedora).
2. Install AutoHotkey into your Wine prefix (default `~/.wine`):

```bash
# Example: download and install AutoHotkey into Wine
wine AutoHotkey_2.0.11_setup.exe
```

3. Ensure `AutoHotkeyU64.exe` and `Ahk2Exe.exe` are on Wine's PATH or set `AHK_BINARY` / `AHK2EXE_BINARY` in `configure()`.

Optional environment variables:

| Variable | Default | Purpose |
|----------|---------|---------|
| `WINE` | `wine` | Wine launcher binary |
| `WINEPREFIX` | `~/.wine` | Wine prefix directory |
| `AHK_BINARY` | `AutoHotkeyU64.exe` | AutoHotkey interpreter |
| `AHK2EXE_BINARY` | `Ahk2Exe.exe` | AutoHotkey compiler |

## Install

```lua
reqpack { beez = { { name = "coditary/ahk", version = "1.0.0", source = "github:Coditary/beez-ahk" } } }
```

## Usage

```lua
configure({ { "coditary/ahk", {} } })
```

```bash
beez -p compile[ahk]
beez -s ahk:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `ahk` | `wine AutoHotkeyU64.exe /version` | Verifies Wine + AutoHotkey |
| compile | `ahk` | `wine AutoHotkeyU64.exe /ErrorStdOut …` | Syntax-checks all `.ahk` files |
| bundle | `ahk` | verify compile stamp | Checks `build/ahk/bin/.ahk-compile-*` |
| test | `ahk` | run entry script under Wine | Writes `report/test/ahk-*.ok` |

## Detection

- Markers: `**/*.ahk`
- Entry point: `main.ahk`, `index.ahk`, or first non-test source file
- Compile targets: all non-test `.ahk` files via `ctx.glob`

## License

Apache License 2.0.
