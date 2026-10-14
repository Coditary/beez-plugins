# jscript

Official Microsoft JScript plugin — syntax-check `.js` and `.jse` scripts via Wine `cscript.exe` on Linux/macOS.

Plugin ID: **`coditary/jscript`**

## Requirements

**Wine is required.** JScript runs through Windows Script Host under Wine.

1. Install [Wine](https://www.winehq.org/) (e.g. `dnf install wine` on Fedora).
2. Ensure `cscript.exe` is available in your Wine prefix (ships with Windows Script Host).

Optional environment variables:

| Variable | Default | Purpose |
|----------|---------|---------|
| `WINE` | `wine` | Wine launcher binary |
| `WINEPREFIX` | `~/.wine` | Wine prefix directory |
| `CSCRIPT_BINARY` | `cscript.exe` | Windows Script Host binary |

## Install

```lua
reqpack { beez = { { name = "coditary/jscript", version = "1.0.0", source = "github:Coditary/beez-jscript" } } }
```

## Usage

```lua
configure({ { "coditary/jscript", {} } })
workflows({ build = "coditary/jscript:build" })
```

```bash
beez build
beez -p compile[jscript]
beez -s jscript:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `jscript` | `wine cscript.exe //?` | Verifies Wine + cscript |
| compile | `jscript` | `wine cscript //Nologo //E:jscript //B …` | Syntax-checks all `.js`/`.jse` files |
| bundle | `jscript` | verify compile stamp | Checks `build/jscript/bin/.jscript-compile-*` |
| test | `jscript` | run entry script under Wine | Writes `report/test/jscript-*.ok` |

## Detection

- Markers: `**/*.js`, `**/*.jse`
- Entry point: `main.js`, `index.js`, `main.jse`, or first non-test source file
- Compile targets: all non-test `.js`/`.jse` files via `ctx.glob`

## License

Apache License 2.0.
