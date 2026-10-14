# docbook

Official DocBook XML documentation plugin — xsltproc HTML and FOP PDF with auto-detected entry point.

Plugin ID: **`coditary/docbook`**

## Install

```lua
reqpack { beez = { { name = "coditary/docbook", version = "1.0.0", source = "github:Coditary/beez-docbook" } } }
```

## Usage

```lua
configure({ { "coditary/docbook", {} } })
```

```bash
beez -p compile[docbook]
beez -s docbook:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `docbook` | `xsltproc --version` + `fop -version` | Verifies toolchain |
| compile | `docbook` | `xsltproc … → app.html` | HTML via DocBook XSL |
| compile | `debug` | `xsltproc + fop → app.pdf` | PDF via FO intermediate |
| bundle | `docbook` | verify output | Checks generated artifact |
| test | `test` | `xmllint --noout` | Validates DocBook XML |

## Detection

- Markers: `**/*.xml`
- Entry points: `main.xml`, `index.xml`, `book.xml`, or first root document
- Stylesheets: system DocBook XSL (configurable via `stylesheet` / `fo_stylesheet`)

## License

Apache License 2.0.
