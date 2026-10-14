# inform7

Inform 7 interactive fiction compiler to Z-machine/Glulx story files.

Plugin ID: **`coditary/inform7`**

## Install

```lua
reqpack { beez = { { name = "coditary/inform7", version = "1.0.0", source = "github:Coditary/beez-inform7" } } }
```

## Usage

```lua
configure({ { "coditary/inform7", {} } })
workflows({ build = "coditary/inform7:build" })
```

```bash
beez -p compile[inform7]
beez -s inform7:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `inform7` | Verify `inform7` binary, prepare `build/inform7/` |
| compile | `inform7` | Compile Inform 7 sources to story file with inform7 |
| bundle | `inform7` | Verify Inform 7 story file artifacts |
| test | `inform7` | Verify Inform 7 build outputs exist |

## Detection

- Markers: **/*.i7x, **/*.i7source
- Binary: `inform7` (override with `INFORM7` env or `inform7_binary` config)

## License

Apache License 2.0.
