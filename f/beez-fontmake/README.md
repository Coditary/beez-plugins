# fontmake

Official Fontmake plugin — compile designspace, UFO, and Glyphs sources to OpenType/TTF via the Python `fontmake` tool.

Plugin ID: **`coditary/fontmake`**

## Install

```lua
reqpack { beez = { { name = "coditary/fontmake", version = "1.0.0", source = "github:Coditary/beez-fontmake" } } }
```

## Usage

```lua
configure({ { "coditary/fontmake", {} } })
```

```bash
beez -p compile[fontmake]
beez -s fontmake:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `fontmake` | `fontmake --version` | Verifies fontmake binary |
| compile | `fontmake` | `fontmake -m/-g/-u … -o otf -o ttf` | Generates fonts in `build/fontmake/bin/` |
| bundle | `fontmake` | verify output | Checks OTF/TTF artifacts |
| test | `fontmake` | compile test fonts | Validates font compilation |

## Detection

- Markers: `**/*.designspace`, `**/*.ufo`, `**/*.glyphs`
- Entry point: first designspace, then glyphs, then UFO, or `entry_source` in configure()
- Output: OTF + TTF (code profile), TTF only (debug profile)

## License

Apache License 2.0.
