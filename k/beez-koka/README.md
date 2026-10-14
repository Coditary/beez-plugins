# koka

Official Koka compiler — algebraic effects with C backend, auto-detected `*.kk` sources.

Plugin ID: **`coditary/koka`**

## Install

```lua
reqpack { beez = { { name = "coditary/koka", version = "1.0.0", source = "github:Coditary/beez-koka" } } }
```

## Usage

```lua
configure({ { "coditary/koka", {} } })
```

```bash
beez -p compile[koka]
beez -s koka:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `koka` | `koka --version` | Verifies Koka compiler binary |
| compile | `koka` | `koka -o build/koka/bin/app main.kk` | Native binary via C backend |
| bundle | `koka` | verify binary | Checks `build/koka/bin/app` |
| test | `koka` | `koka test` | Skipped when no test files are detected |

## Detection

- Markers: `package.toml`, `**/*.kk`
- Entry: `main.kk`, `src/main.kk`, first non-test `*.kk`
- Tests: `test/**/*.kk`, `tests/**/*.kk`, `*_test.kk`

## License

Apache License 2.0.
