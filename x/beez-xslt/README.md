# XSLT

xsltproc — XSLT/XQuery transform validation for auto-detected *.xsl and *.xq targets

Plugin ID: **`coditary/xslt`**

## Install

```lua
reqpack { beez = { { name = "coditary/xslt", version = "1.0.0", source = "github:Coditary/beez-xslt" } } }
```

## Usage

```lua
configure({ { "coditary/xslt", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[xslt]
beez -s coditary/xslt:compile:code
```

## Detection

- Markers: `**/*.xsl`, `**/*.xslt`, `**/*.xq`, `**/*.xquery`
- Binary: `xsltproc` (override with `XSLTPROC` env or config)

## License

Apache License 2.0.
