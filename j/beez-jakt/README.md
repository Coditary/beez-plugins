# jakt

Official Jakt compiler — SerenityOS language transpiling to C++, auto-detected `*.jakt` sources.

Plugin ID: **`coditary/jakt`**

## Install

```lua
reqpack { beez = { { name = "coditary/jakt", version = "1.0.0", source = "github:Coditary/beez-jakt" } } }
```

## Usage

```lua
configure({ { "coditary/jakt", {} } })
```

```bash
beez -p compile[jakt]
beez -s jakt:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `jakt` | `jakt -h` | Verifies Jakt compiler binary |
| compile | `jakt` | `jakt -O src/main.jakt -o app` | Native binary via C++ backend |
| bundle | `jakt` | verify binary | Checks `build/jakt/bin/app` |
| test | `jakt` | `jakttest` | Skipped when `JAKTTEST` is unset |

## Detection

- Markers: `**/*.jakt`
- Entry: `main.jakt`, `src/main.jakt`, first `*.jakt`
- Tests: `tests/**/*.jakt`, `test/**/*.jakt`, `*_test.jakt`

## License

Apache License 2.0.
