# amiga-e

Official Amiga E compiler — `ec` 68000 backend with auto-detected `*.e` entry point.

Plugin ID: **`coditary/amiga-e`**

## Install

```lua
reqpack { beez = { { name = "coditary/amiga-e", version = "1.0.0", source = "github:Coditary/beez-amiga-e" } } }
```

## Usage

```lua
configure({ { "coditary/amiga-e", {} } })
```

```bash
beez -p compile[amiga-e]
beez -s amiga-e:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `amiga-e` | `command -v ec` | Verifies Amiga E compiler binary |
| compile | `amiga-e` | `ec <basename>` | 68000 Amiga executable |
| bundle | `amiga-e` | verify binary | Checks `build/amiga-e/bin/app` |
| test | `amiga-e` | `ec` on test sources | Skipped when no test files are detected |

## Detection

- Markers: `**/*.e`
- Entry points: `main.e`, `src/main.e`, or first root `*.e`
- Tests: `**/*_test.e`, `test/**/*.e`, `tests/**/*.e`

## License

Apache License 2.0.
