# metapost

Official MetaPost plugin — render diagrams from `*.mp` sources via `mpost`.

Plugin ID: **`coditary/metapost`**

## Install

```lua
reqpack { beez = { { name = "coditary/metapost", version = "1.0.0", source = "github:Coditary/beez-metapost" } } }
```

## Usage

```lua
configure({ { "coditary/metapost", {} } })
```

```bash
beez -p compile[metapost]
beez -s metapost:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `metapost` | `mpost --version` | Verifies MetaPost binary |
| compile | `metapost` | `mpost -output-format=pdf …` | Generates `build/metapost/bin/app.pdf` |
| bundle | `metapost` | verify output | Checks rendered diagram |
| test | `metapost` | render test output | Validates MetaPost rendering |

## Detection

- Markers: `**/*.mp`
- Entry point: first non-test `.mp` file, or `entry_source` in configure()
- Formats: PDF (code profile), SVG (debug profile)

## License

Apache License 2.0.
