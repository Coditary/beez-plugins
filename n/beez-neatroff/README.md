# neatroff

Official Neatroff plugin — compile troff successor documents (`*.ms`, `*.nr`, `*.roff`) to PostScript.

Plugin ID: **`coditary/neatroff`**

## Install

```lua
reqpack { beez = { { name = "coditary/neatroff", version = "1.0.0", source = "github:Coditary/beez-neatroff" } } }
```

## Usage

```lua
configure({ { "coditary/neatroff", {} } })
```

```bash
beez -p compile[neatroff]
beez -s neatroff:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `neatroff` | `neatroff --version` | Verifies Neatroff binary |
| compile | `neatroff` | `neatroff -Tps document.ms > …` | Generates `build/neatroff/bin/app.ps` |
| bundle | `neatroff` | verify output | Checks generated artifact |
| test | `neatroff` | version check | Validates document sources when test files exist |

## Detection

- Markers: `**/*.ms`, `**/*.nr`, `**/*.roff`
- Entry point: `main.ms`, `document.ms`, or `entry_source` in configure()
- Tests: `test/**/*.ms`, `test/**/*.nr`, `*_test.ms`

## License

Apache License 2.0.
