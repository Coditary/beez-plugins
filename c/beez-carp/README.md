# carp

Official Carp compiler — Lisp-to-C native codegen with auto-detected `Carp.toml` project layout.

Plugin ID: **`coditary/carp`**

## Install

```lua
reqpack { beez = { { name = "coditary/carp", version = "1.0.0", source = "github:Coditary/beez-carp" } } }
```

## Usage

```lua
configure({ { "coditary/carp", {} } })
```

```bash
beez -p compile[carp]
beez -s carp:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `carp` | `carp --help` | Verifies Carp compiler binary |
| compile | `carp` | `carp -b '(build)'` | Transpiles to C and links native binary |
| bundle | `carp` | verify binary | Checks `build/carp/bin/app` |
| test | `carp` | `carp -b '(run-tests)'` | Skipped when no test files are detected |

## Detection

- Markers: `Carp.toml`, `**/*.carp`
- Project root: directory containing `Carp.toml`
- Tests: `test/**/*.carp`, `tests/**/*.carp`, `*_test.carp`

## License

Apache License 2.0.
