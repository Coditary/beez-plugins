# kixtart

Official KiXtart plugin — syntax-check `.kix` scripts via Wine `kix32.exe` on Linux/macOS.

Plugin ID: **`coditary/kixtart`**

## Requirements

**Wine is required.** KiXtart is Windows-only; this plugin runs `kix32.exe` under Wine.

1. Install [Wine](https://www.winehq.org/) (e.g. `dnf install wine` on Fedora).
2. Install KiXtart into your Wine prefix and ensure `kix32.exe` is on PATH.

Optional environment variables:

| Variable | Default | Purpose |
|----------|---------|---------|
| `WINE` | `wine` | Wine launcher binary |
| `WINEPREFIX` | `~/.wine` | Wine prefix directory |
| `KIX_BINARY` | `kix32.exe` | KiXtart interpreter |

## Install

```lua
reqpack { beez = { { name = "coditary/kixtart", version = "1.0.0", source = "github:Coditary/beez-kixtart" } } }
```

## Usage

```lua
configure({ { "coditary/kixtart", {} } })
workflows({ build = "coditary/kixtart:build" })
```

```bash
beez build
beez -p compile[kixtart]
beez -s kixtart:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `kixtart` | `wine kix32.exe /?` | Verifies Wine + KiXtart |
| compile | `kixtart` | `wine kix32.exe /c …` | Syntax-checks all `.kix` files |
| bundle | `kixtart` | verify compile stamp | Checks `build/kixtart/bin/.kixtart-compile-*` |
| test | `kixtart` | syntax-check entry script | Writes `report/test/kixtart-*.ok` |

## Detection

- Markers: `**/*.kix`
- Entry point: `main.kix`, `index.kix`, or first non-test source file
- Compile targets: all non-test `.kix` files via `ctx.glob`

## License

Apache License 2.0.
