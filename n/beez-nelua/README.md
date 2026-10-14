# nelua

Official Nelua compiler — `nelua→C` with auto-detected entry point and `project.nelua` support.

Plugin ID: **`coditary/nelua`**

## Install

```lua
reqpack { beez = { { name = "coditary/nelua", version = "1.0.0", source = "github:Coditary/beez-nelua" } } }
```

## Usage

```lua
configure({ { "coditary/nelua", {} } })
```

```bash
beez -p compile[nelua]
beez -s nelua:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `nelua` | `nelua --version` | Verifies Nelua compiler binary |
| compile | `nelua` | `nelua -o build/nelua/bin/app` | Native binary via C backend |
| compile (debug) | `nelua` | `nelua --gen c -o build/nelua/gen/app.c` | C code generation only |
| bundle | `nelua` | verify binary or C output | Checks build artifacts |
| test | `nelua` | run binary or entry | Skipped when no tests detected |

## Detection

- Markers: `project.nelua`, `**/*.nelua`
- Entry points: `main.nelua`, `src/main.nelua`, or first root `*.nelua`
- Tests: `tests/**/*.nelua`, `test/**/*.nelua`, `*_test.nelua`

## License

Apache License 2.0.
