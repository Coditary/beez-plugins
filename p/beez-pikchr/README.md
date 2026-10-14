# pikchr

Official Pikchr plugin — render inline SVG diagrams from Pikchr sources.

Plugin ID: **`coditary/pikchr`**

## Install

```lua
reqpack { beez = { { name = "coditary/pikchr", version = "1.0.0", source = "github:Coditary/beez-pikchr" } } }
```

## Usage

```lua
configure({ { "coditary/pikchr", {} } })
```

```bash
beez -p compile[pikchr]
beez -s pikchr:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `pikchr` | verify binary | Checks Pikchr is available |
| compile | `pikchr` | `pikchr < src > out.svg` | Generates `build/pikchr/bin/app.svg` |
| bundle | `pikchr` | verify output | Checks rendered SVG |
| test | `pikchr` | render to /dev/null | Validates Pikchr sources |

## Detection

- Markers: `**/*.pikchr`, `**/*.pik`
- Entry point: first non-test Pikchr file, or `entry_source` in configure()

## License

Apache License 2.0.
