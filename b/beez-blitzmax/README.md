# blitzmax

Official BlitzMax compiler — `bmk makeapp` with auto-detected `*.bmx` entry point.

Plugin ID: **`coditary/blitzmax`**

## Install

```lua
reqpack { beez = { { name = "coditary/blitzmax", version = "1.0.0", source = "github:Coditary/beez-blitzmax" } } }
```

## Usage

```lua
configure({ { "coditary/blitzmax", {} } })
```

```bash
beez -p compile[blitzmax]
beez -s blitzmax:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `blitzmax` | `bmk help` | Verifies BlitzMax Make binary |
| compile | `blitzmax` | `bmk makeapp -r -o build/blitzmax/bin/app` | Release build via bmk |
| bundle | `blitzmax` | verify binary | Checks `build/blitzmax/bin/app` |
| test | `blitzmax` | `bmk makeapp` on test sources | Skipped when no test files are detected |

## Detection

- Markers: `**/*.bmx`
- Entry points: `main.bmx`, `src/main.bmx`, or first root `*.bmx`
- Tests: `**/*_test.bmx`, `test/**/*.bmx`, `tests/**/*.bmx`

## License

Apache License 2.0.
