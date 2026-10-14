# dc

Official dc desk calculator plugin — script validation with auto-detected `*.dc` targets.

Plugin ID: **`coditary/dc`**

## Install

```lua
reqpack { beez = { { name = "coditary/dc", version = "1.0.0", source = "github:Coditary/beez-dc" } } }
```

## Usage

```lua
configure({ { "coditary/dc", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[dc]
beez -s coditary/dc:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `dc` | Creates `build/dc/.dc-setup` |
| compile | `dc -f` | Parses all non-test `.dc` scripts |
| bundle | verify compile stamp | Checks `build/dc/.dc-compile-*` |
| test | run primary script | Executes `main.dc` or first entry |

## Detection

- Markers: `**/*.dc`
- Entry points: `main.dc`, or first non-test script
- Binary: `dc` (override with `DC` env or `dc_binary` config)

## License

Apache License 2.0.
