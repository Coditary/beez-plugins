# ghidra

Official Ghidra plugin — headless binary analysis with analyzeHeadless.

Plugin ID: **`coditary/ghidra`**

## Install

```lua
reqpack { beez = { { name = "coditary/ghidra", version = "1.0.0", source = "github:Coditary/beez-ghidra" } } }
```

## Usage

```lua
configure({ { "coditary/ghidra", {} } })
```

```bash
beez -p compile[ghidra]
beez -s ghidra:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `ghidra` | verify analyzeHeadless | Prepares project workspace |
| compile | `ghidra` | analyzeHeadless -import | Headless decompiler analysis |
| bundle | `ghidra` | verify artifacts | Checks analysis stamp |
| test | `ghidra` | verify binary + output | Validates analysis state |

## Detection

- Markers: `**/*` (binaries, shared objects, executables)
- Entry point: first likely binary, or `entry_source` in configure()
- Set `GHIDRA_INSTALL_DIR` or `ghidra_home` for non-PATH installs

## License

Apache License 2.0.
