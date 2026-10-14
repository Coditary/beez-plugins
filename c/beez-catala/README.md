# catala

Official Catala plugin — computational law DSL compiler to C, Python, or OCaml.

Plugin ID: **`coditary/catala`**

## Install

```lua
reqpack { beez = { { name = "coditary/catala", version = "1.0.0", source = "github:Coditary/beez-catala" } } }
```

## Usage

```lua
configure({ { "coditary/catala", {} } })
```

```bash
beez -p compile[catala]
beez -s catala:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `catala` | `catala --version` | Verifies Catala binary |
| compile | `catala` | `catala -s C -o …` | Generates `build/catala/output.c` |
| bundle | `catala` | verify output | Checks compiled artifact |
| test | `catala` | `catala typecheck` | Validates Catala sources |

## Detection

- Markers: `**/*.catala`
- Entry point: first non-test `.catala` file, or `entry_source` in configure()
- Backends: C (code profile), Python (debug profile)

## License

Apache License 2.0.
