# teal

Official Teal compiler — `tl→Lua` typed with `tlconfig.lua` and auto-detected `.tl` targets.

Plugin ID: **`coditary/teal`**

## Install

```lua
reqpack { beez = { { name = "coditary/teal", version = "1.0.0", source = "github:Coditary/beez-teal" } } }
```

## Usage

```lua
configure({ { "coditary/teal", {} } })
```

```bash
beez -p compile[teal]
beez -s teal:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `teal` | `command -v tl` | Verifies Teal compiler and lua |
| compile | `teal` | `tl build` or `tl gen build/teal main.tl` | Generates Lua from Teal |
| compile (debug) | `teal` | `tl check` | Type-check only, no codegen |
| bundle | `teal` | verify `.lua` output | Checks generated Lua artifacts |
| test | `teal` | `lua build/teal/main.lua` | Runs generated Lua output |

## Detection

- Markers: `tlconfig.lua`, `**/*.tl`
- Entry points: `main.tl`, `src/main.tl`, or first root `*.tl`
- Project mode: uses `tl build` when `tlconfig.lua` is present

## License

Apache License 2.0.
