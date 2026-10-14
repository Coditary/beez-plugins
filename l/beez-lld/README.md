# lld

Official LLVM LLD linker plugin — link object files using compile_commands.json.

Plugin ID: **`coditary/lld`**

## Install

```lua
reqpack { beez = { { name = "coditary/lld", version = "1.0.0", source = "github:Coditary/beez-lld" } } }
```

## Usage

```lua
configure({ { "coditary/lld", {} } })
```

```bash
beez -p compile[lld]
beez -s lld:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `lld` | `ld.lld --version` | Verifies LLD binary |
| compile | `lld` | `ld.lld -o … *.o` | Links object files into `build/lld/bin/app` |
| bundle | `lld` | verify output | Checks linked binary |
| test | `lld` | verify compdb | Validates link setup |

## Detection

- Markers: `compile_commands.json`, `**/*.o`
- CompDB: first non-test `compile_commands.json`, or `compdb` in configure()
- Objects: globbed `**/*.o` excluding test paths

## License

Apache License 2.0.
