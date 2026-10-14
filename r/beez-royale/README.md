# royale

Apache **Royale** — ActionScript to JavaScript compiler with `asconfig.json` auto-detection.

Plugin ID: **`coditary/royale`**

## Install

```lua
reqpack { beez = { { name = "coditary/royale", version = "1.0.0", source = "github:Coditary/beez-royale" } } }
```

## Usage

```lua
configure({ { "coditary/royale", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[royale]
beez -s royale:compile:code
```

## Detection

The plugin detects Royale projects via `ctx.glob`:

| Marker | Build mode |
|--------|------------|
| `asconfig.json` | `asconfigc` / `royale --project asconfig.json` |
| `**/*.as` | `royale --targets JSRoyale` per entry point |

Entry points are inferred from `src/Main.as`, `Main.as`, or the first non-test `.as` file.

## Output

| Profile | Scope | Output |
|---------|-------|--------|
| Release | `royale` | `build/royale/bin/*.js` |
| Debug | `royale` | `build/royale/bin/*.js` (debug flags) |

## License

Apache License 2.0.
