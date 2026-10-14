# curry

Curry — PAKCS/KiCS2 compiler for `.curry` sources.

Plugin ID: **`coditary/curry`**

## Install

```lua
reqpack { beez = { { name = "coditary/curry", version = "1.0.0", source = "github:Coditary/beez-curry" } } }
```

## Usage

```lua
configure({ { "coditary/curry", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[curry]
beez -s curry:compile
```

## Steps

| Phase | Step | Notes |
|-------|------|-------|
| setup | `configure:setup` / `configure:debug` | Verify `curry` binary (PAKCS/KiCS2) |
| compile | `compile:code` / `compile:debug` | Compile with `curry :load Mod :save :quit` |
| bundle | `bundle:code` / `bundle:debug` | Verify build artifacts |
| test | `test:unit` / `test:debug` | Evaluates `main` via `curry :eval` |

## Detection

- Markers: `**/*.curry`, `**/*.lcurry`
- Entry points: `Main.curry`, `main.curry`, or first non-test source file
- Works with both PAKCS and KiCS2 via the unified `curry` command

## License

Apache License 2.0.
