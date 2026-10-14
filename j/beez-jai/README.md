# jai

Official Jai compiler — `jai build.jai` with auto-detected project layout.

Plugin ID: **`coditary/jai`**

## Install

```lua
reqpack { beez = { { name = "coditary/jai", version = "1.0.0", source = "github:Coditary/beez-jai" } } }
```

## Usage

```lua
configure({ { "coditary/jai", {} } })
```

```bash
beez -p compile[jai]
beez -s jai:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `jai` | verify `jai` binary | Checks Jai compiler availability |
| compile | `jai` | `jai build.jai - -output_path build/jai/bin/app` | Native binary output |
| bundle | `jai` | verify binary | Checks `build/jai/bin/app` |
| test | `jai` | `jai build.jai - test` | Skipped when no test files are detected |

## Detection

- Markers: `build.jai`, `**/*.jai`
- Entry points: `build.jai`, `main.jai`, `first.jai`, or first root `*.jai`
- Tests: `tests/**/*.jai`, `test/**/*.jai`, `*_test.jai`

## License

Apache License 2.0.
