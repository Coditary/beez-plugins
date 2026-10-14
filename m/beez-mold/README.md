# mold

Official Mold fast linker plugin — link object files using compile_commands.json.

Plugin ID: **`coditary/mold`**

## Install

```lua
reqpack { beez = { { name = "coditary/mold", version = "1.0.0", source = "github:Coditary/beez-mold" } } }
```

## Usage

```lua
configure({ { "coditary/mold", {} } })
```

```bash
beez -p compile[mold]
beez -s mold:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `mold` | `mold --version` | Verifies Mold binary |
| compile | `mold` | `mold -o … *.o` | Links object files into `build/mold/bin/app` |
| bundle | `mold` | verify output | Checks linked binary |
| test | `mold` | verify compdb | Validates link setup |

## Detection

- Markers: `compile_commands.json`, `**/*.o`
- CompDB: first non-test `compile_commands.json`, or `compdb` in configure()
- Objects: globbed `**/*.o` excluding test paths

## License

Apache License 2.0.
