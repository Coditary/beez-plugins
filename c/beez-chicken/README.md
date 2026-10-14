# chicken

Official Chicken Scheme compiler — `csc` with auto-detected targets.

Plugin ID: **`coditary/chicken`**

## Install

```lua
reqpack { beez = { { name = "coditary/chicken", version = "1.0.0", source = "github:Coditary/beez-chicken" } } }
```

## Usage

```lua
configure({ { "coditary/chicken", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[chicken]
beez -s coditary/chicken:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `csc` | Creates `build/chicken/.chicken-setup` |
| compile | `csc -O3 -o …` | Output under `build/chicken/bin/` |
| bundle | verify binary | Checks `build/chicken/bin/*` |
| test | run binary | Executes compiled program |

## Detection

- Markers: `*.scm`, `**/*.scm`, `*.setup`
- Entry points: `main.scm`, `src/main.scm`, or first non-test `*.scm`

## License

Apache License 2.0.
