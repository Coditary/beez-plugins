# prince

Official PrinceXML plugin — render HTML+CSS documents to PDF.

Plugin ID: **`coditary/prince`**

## Install

```lua
reqpack { beez = { { name = "coditary/prince", version = "1.0.0", source = "github:Coditary/beez-prince" } } }
```

## Usage

```lua
configure({ { "coditary/prince", {} } })
```

```bash
beez -p compile[prince]
beez -s prince:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `prince` | `prince --version` | Verifies PrinceXML binary |
| compile | `prince` | `prince -o … input.html` | Generates `build/prince/bin/app.pdf` |
| bundle | `prince` | verify output | Checks rendered PDF |
| test | `prince` | render test output | Validates HTML-to-PDF rendering |

## Detection

- Markers: `**/*.html`, `**/*.htm`
- Entry point: `index.html` or first non-test HTML file, or `entry_source` in configure()
- Output: PDF via PrinceXML

## License

Apache License 2.0.
