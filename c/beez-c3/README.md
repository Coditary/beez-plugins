# c3

Official C3 compiler — `c3c` LLVM backend with auto-detected `project.json` layout.

Plugin ID: **`coditary/c3`**

## Install

```lua
reqpack { beez = { { name = "coditary/c3", version = "1.0.0", source = "github:Coditary/beez-c3" } } }
```

## Usage

```lua
configure({ { "coditary/c3", {} } })
```

```bash
beez -p compile[c3]
beez -s c3:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `c3` | `c3c --version` | Verifies C3 compiler binary |
| compile | `c3` | `c3c compile -o build/c3/bin/app` | Native binary via LLVM backend |
| bundle | `c3` | verify binary | Checks `build/c3/bin/app` |
| test | `c3` | `c3c test-run` | Skipped when no test files are detected |

## Detection

- Markers: `project.json`, `**/*.c3`
- Tests: `tests/**/*.c3`, `test/**/*.c3`, `*_test.c3`

## License

Apache License 2.0.
