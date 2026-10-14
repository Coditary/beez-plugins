# ballerina

Official Ballerina plugin — `bal build` with auto-detected `Ballerina.toml` and `.bal` sources.

Plugin ID: **`coditary/ballerina`**

## Install

```lua
reqpack { beez = { { name = "coditary/ballerina", version = "1.0.0", source = "github:Coditary/beez-ballerina" } } }
```

## Usage

```lua
configure({ { "coditary/ballerina", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[ballerina]
beez -s ballerina:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `bal` | Writes setup stamp under `build/ballerina/` |
| compile | `bal build` from project root | Writes compile stamp under `build/ballerina/` |
| bundle | verify compile stamp | Checks `build/ballerina/.ballerina-compile-*` |
| test | placeholder test runner | Writes `report/test/ballerina-*.ok` |

## Detection

- Markers: `Ballerina.toml`, `**/Ballerina.toml`, `**/*.bal`
- Compile targets: auto-detected source files (excluding test paths)
- Binary: `bal` (override with `BAL` env or `ballerina_binary` config)

## License

Apache License 2.0.
