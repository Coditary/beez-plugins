# abc

Official ABC notation plugin — render music scores (`*.abc`) to PDF via `abcm2ps`.

Plugin ID: **`coditary/abc`**

## Install

```lua
reqpack { beez = { { name = "coditary/abc", version = "1.0.0", source = "github:Coditary/beez-abc" } } }
```

## Usage

```lua
configure({ { "coditary/abc", {} } })
```

```bash
beez -p compile[abc]
beez -s abc:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `abc` | `abcm2ps -V` | Verifies abcm2ps binary |
| compile | `abc` | `abcm2ps -O … …` + `ps2pdf` | Generates `build/abc/bin/app.pdf` |
| bundle | `abc` | verify output | Checks generated PDF/PS |
| test | `abc` | render to test.ps | Validates ABC sources when test files exist |

## Detection

- Markers: `**/*.abc`
- Entry point: first non-test `*.abc`, or `entry_source` in configure()
- Tests: `test/**/*.abc`, `test_*.abc`, `*_test.abc`

## License

Apache License 2.0.
