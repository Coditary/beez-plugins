# patoline

Official Patoline OCaml typesetting compiler — `patoline` with auto-detected `.tli` entry point.

Plugin ID: **`coditary/patoline`**

## Install

```lua
reqpack { beez = { { name = "coditary/patoline", version = "1.0.0", source = "github:Coditary/beez-patoline" } } }
```

## Usage

```lua
configure({ { "coditary/patoline", {} } })
```

```bash
beez -p compile[patoline]
beez -s patoline:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `patoline` | `patoline --version` | Verifies Patoline binary |
| compile | `patoline` | `patoline -o build/patoline/out/main.pdf main.tli` | Patoline document to PDF |
| bundle | `patoline` | verify PDF | Checks `build/patoline/out/main.pdf` |
| test | `patoline` | compile test `.tli` files | Skipped when no test files are detected |

## Detection

- Markers: `**/*.tli`
- Entry points: `main.tli`, `document.tli`, or first root `*.tli`
- Tests: `tests/**/*.tli`, `test/**/*.tli`, `*_test.tli`

## License

Apache License 2.0.
