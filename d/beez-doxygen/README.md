# doxygen

Official Doxygen API documentation plugin — `doxygen Doxyfile` with auto-detected configuration.

Plugin ID: **`coditary/doxygen`**

## Install

```lua
reqpack { beez = { { name = "coditary/doxygen", version = "1.0.0", source = "github:Coditary/beez-doxygen" } } }
```

## Usage

```lua
configure({ { "coditary/doxygen", {} } })
```

```bash
beez -p compile[doxygen]
beez -s doxygen:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `doxygen` | `doxygen --version` | Verifies Doxygen binary |
| compile | `doxygen` | `doxygen Doxyfile` | Builds `build/doxygen/html/index.html` |
| bundle | `doxygen` | verify output | Checks generated HTML index |
| test | `test` | `doxygen -s Doxyfile` | Validates Doxygen configuration |

When no `Doxyfile` is present but source files exist, compile generates a minimal inline configuration.

## Detection

- Markers: `Doxyfile`, `**/*.c`, `**/*.cpp`, `**/*.h`, `**/*.go`
- Project dir: directory containing `Doxyfile`

## License

Apache License 2.0.
