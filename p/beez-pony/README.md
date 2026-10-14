# pony

Official Pony compiler plugin — Pony ponyc LLVM — compile .pony with corral dependency support.

Plugin ID: **`coditary/pony`**

## Install

```lua
reqpack { beez = { { name = "coditary/pony", version = "1.0.0", source = "github:Coditary/beez-pony" } } }
```

## Usage

```lua
configure({ { "coditary/pony", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[pony]
beez -s coditary/pony:compile:code
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `pony` | Verify toolchain, create `build/pony/.pony-setup` |
| compile | `pony` | Compile sources to `build/pony/` |
| bundle | `pony` | Verify compile artifacts |
| test | `pony` | Writes `report/test/pony-*.ok` |

## Detection

- Markers: **/*.pony, corral.json
- Entry points: `main.pony`, `src/main.pony`, or first non-test `*.pony`

## License

Apache License 2.0.
