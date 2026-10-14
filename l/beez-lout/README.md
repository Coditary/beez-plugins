# lout

Official Lout typesetting compiler — `lout -PDF` with auto-detected `.lt` entry point.

Plugin ID: **`coditary/lout`**

## Install

```lua
reqpack { beez = { { name = "coditary/lout", version = "1.0.0", source = "github:Coditary/beez-lout" } } }
```

## Usage

```lua
configure({ { "coditary/lout", {} } })
```

```bash
beez -p compile[lout]
beez -s lout:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `lout` | `lout -V` | Verifies Lout binary |
| compile | `lout` | `lout -PDF -o build/lout/out/main.pdf main.lt` | Lout document to PDF |
| bundle | `lout` | verify PDF | Checks `build/lout/out/main.pdf` |
| test | `lout` | compile test `.lt` files | Skipped when no test files are detected |

## Detection

- Markers: `**/*.lt`
- Entry points: `main.lt`, `document.lt`, or first root `*.lt`
- Tests: `tests/**/*.lt`, `test/**/*.lt`, `*_test.lt`

## License

Apache License 2.0.
