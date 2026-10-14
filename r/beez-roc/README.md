# roc

Official Roc compiler — `roc build` with auto-detected `app.roc` entry point.

Plugin ID: **`coditary/roc`**

## Install

```lua
reqpack { beez = { { name = "coditary/roc", version = "1.0.0", source = "github:Coditary/beez-roc" } } }
```

## Usage

```lua
configure({ { "coditary/roc", {} } })
```

```bash
beez -p compile[roc]
beez -s roc:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `roc` | `roc version` | Verifies Roc compiler binary |
| compile | `roc` | `roc build app.roc -o build/roc/bin/app` | LLVM native binary output |
| bundle | `roc` | verify binary | Checks `build/roc/bin/app` |
| test | `roc` | `roc test` | Skipped when no test files are detected |

## Detection

- Markers: `app.roc`, `**/*.roc`
- Entry: `app.roc` or `main.roc` (shallowest match)
- Tests: `tests/**/*.roc`, `test/**/*.roc`, `*_test.roc`

## License

Apache License 2.0.
