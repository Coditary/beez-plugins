# pallene

Official Pallene compiler — `pallenec→C` Lua C extension with auto-detected `.pln` targets.

Plugin ID: **`coditary/pallene`**

## Install

```lua
reqpack { beez = { { name = "coditary/pallene", version = "1.0.0", source = "github:Coditary/beez-pallene" } } }
```

## Usage

```lua
configure({ { "coditary/pallene", {} } })
```

```bash
beez -p compile[pallene]
beez -s pallene:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `pallene` | `command -v pallenec` | Verifies Pallene compiler and lua |
| compile | `pallene` | `pallenec -o build/pallene/bin/app main.pln` | Lua C extension (.so) |
| compile (debug) | `pallene` | `pallenec --keep-c ...` | Keeps generated C for inspection |
| bundle | `pallene` | verify `.so` module | Checks `build/pallene/bin/*.so` |
| test | `pallene` | `lua -e 'require("app")'` | Loads compiled module |

## Detection

- Markers: `**/*.pln`
- Entry points: `main.pln`, `src/main.pln`, or first root `*.pln`
- Tests: `tests/**/*.pln`, `test/**/*.pln`, `*_test.pln`

## License

Apache License 2.0.
