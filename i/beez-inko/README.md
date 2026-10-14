# inko

Official Inko compiler — Ruby-like LLVM ownership language with auto-detected entry.

Plugin ID: **`coditary/inko`**

## Install

```lua
reqpack { beez = { { name = "coditary/inko", version = "1.0.0", source = "github:Coditary/beez-inko" } } }
```

## Usage

```lua
configure({ { "coditary/inko", {} } })
```

```bash
beez -p compile[inko]
beez -s inko:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `inko` | `inko --version` | Verifies Inko compiler binary |
| compile | `inko` | `inko build --release src/main.inko` | Copies to `build/inko/bin/app` |
| bundle | `inko` | verify binary | Checks `build/inko/bin/app` |
| test | `inko` | `inko test` | Skipped when no test files detected |

## Detection

- Markers: `**/*.inko`
- Entry points: `src/main.inko`, `main.inko`, `src/*.inko`, or first non-test `*.inko`
- Tests: `tests/**/*.inko`, `test/**/*.inko`, `*_test.inko`

## License

Apache License 2.0.
