# autoit

Official AutoIt plugin — syntax-check `.au3` scripts via Wine on Linux/macOS.

Plugin ID: **`coditary/autoit`**

## Requirements

**Wine is required.** AutoIt is Windows-only; this plugin runs `AutoIt3.exe` and `Aut2exe.exe` under Wine.

1. Install [Wine](https://www.winehq.org/) (e.g. `dnf install wine` on Fedora).
2. Install AutoIt into your Wine prefix (default `~/.wine`):

```bash
# Example: download and install AutoIt into Wine
wine autoit-v3-setup.exe
```

3. Ensure `AutoIt3.exe` and `Aut2exe.exe` are on Wine's PATH or set `AUTOIT3_BINARY` / `AUT2EXE_BINARY` in `configure()`.

Optional environment variables:

| Variable | Default | Purpose |
|----------|---------|---------|
| `WINE` | `wine` | Wine launcher binary |
| `WINEPREFIX` | `~/.wine` | Wine prefix directory |
| `AUTOIT3_BINARY` | `AutoIt3.exe` | AutoIt interpreter |
| `AUT2EXE_BINARY` | `Aut2exe.exe` | AutoIt compiler |

## Install

```lua
reqpack { beez = { { name = "coditary/autoit", version = "1.0.0", source = "github:Coditary/beez-autoit" } } }
```

## Usage

```lua
configure({ { "coditary/autoit", {} } })
```

```bash
beez -p compile[autoit]
beez -s autoit:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `autoit` | `wine AutoIt3.exe /version` | Verifies Wine + AutoIt |
| compile | `autoit` | `wine AutoIt3.exe /ErrorStdOut …` | Syntax-checks all `.au3` files |
| bundle | `autoit` | verify compile stamp | Checks `build/autoit/bin/.autoit-compile-*` |
| test | `autoit` | run entry script under Wine | Writes `report/test/autoit-*.ok` |

## Detection

- Markers: `**/*.au3`
- Entry point: `main.au3`, `index.au3`, or first non-test source file
- Compile targets: all non-test `.au3` files via `ctx.glob`

## License

Apache License 2.0.
