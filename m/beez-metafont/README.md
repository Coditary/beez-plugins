# metafont

Official Metafont plugin — compile Donald Knuth Metafont sources to GF/PK fonts via `mf-nowin`.

Plugin ID: **`coditary/metafont`**

## Install

```lua
reqpack { beez = { { name = "coditary/metafont", version = "1.0.0", source = "github:Coditary/beez-metafont" } } }
```

## Usage

```lua
configure({ { "coditary/metafont", {} } })
```

```bash
beez -p compile[metafont]
beez -s metafont:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `metafont` | `mf-nowin -version` | Verifies Metafont binary |
| compile | `metafont` | `mf-nowin '\mode:=localfont; input …'` | Generates GF/PK in `build/metafont/bin/` |
| bundle | `metafont` | verify output | Checks GF/PK artifacts |
| test | `metafont` | compile test fonts | Validates font compilation |

## Detection

- Markers: `**/*.mf`, `**/*.fd`
- Entry point: first non-test `.mf` file, or `entry_source` in configure()
- Mode: `localfont` (code profile), `proof` (debug profile)

## License

Apache License 2.0.
