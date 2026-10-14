# groff

Official groff/troff plugin — format man pages and ms/roff sources to PDF or PostScript.

Plugin ID: **`coditary/groff`**

## Install

```lua
reqpack { beez = { { name = "coditary/groff", version = "1.0.0", source = "github:Coditary/beez-groff" } } }
```

## Usage

```lua
configure({ { "coditary/groff", {} } })
```

```bash
beez -p compile[groff]
beez -s groff:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `groff` | `groff --version` | Verifies groff binary |
| compile | `groff` | `groff -man/-ms -Tpdf …` | Generates `build/groff/bin/app.pdf` |
| bundle | `groff` | verify output | Checks generated document |
| test | `groff` | `groff -Tascii …` | Validates source formatting |

## Detection

- Markers: `**/*.ms`, `**/*.man`, `**/*.roff`
- Entry point: first non-test source, or `entry_source` in configure()
- Macro package: `-man` for `.man`, `-ms` for `.ms`

## License

Apache License 2.0.
