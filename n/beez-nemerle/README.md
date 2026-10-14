# nemerle

Official Nemerle compiler plugin — Nemerle ncc — compile .n sources to .NET CIL assemblies.

Plugin ID: **`coditary/nemerle`**

## Install

```lua
reqpack { beez = { { name = "coditary/nemerle", version = "1.0.0", source = "github:Coditary/beez-nemerle" } } }
```

## Usage

```lua
configure({ { "coditary/nemerle", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[nemerle]
beez -s coditary/nemerle:compile:code
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `nemerle` | Verify toolchain, create `build/nemerle/.nemerle-setup` |
| compile | `nemerle` | Compile sources to `build/nemerle/` |
| bundle | `nemerle` | Verify compile artifacts |
| test | `nemerle` | Writes `report/test/nemerle-*.ok` |

## Detection

- Markers: **/*.n
- Entry points: `main.n`, `src/main.n`, or first non-test `*.n`

## License

Apache License 2.0.
