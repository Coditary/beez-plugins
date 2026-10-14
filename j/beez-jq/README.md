# jq

Official jq compiler plugin — `jq -n -f` validation with auto-detected `*.jq` targets.

Plugin ID: **`coditary/jq`**

## Install

```lua
reqpack { beez = { { name = "coditary/jq", version = "1.0.0", source = "github:Coditary/beez-jq" } } }
```

## Usage

```lua
configure({ { "coditary/jq", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[jq]
beez -s coditary/jq:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `jq` | Creates `build/jq/.jq-setup` |
| compile | `jq -n -f` | Validates all non-test filters |
| bundle | verify compile stamp | Checks `build/jq/.jq-compile-*` |
| test | run primary filter | Executes `main.jq` or first entry |

## Detection

- Markers: `**/*.jq`
- Entry points: `main.jq`, or first non-test filter
- Binary: `jq` (override with `JQ` env or `jq_binary` config)

## License

Apache License 2.0.
