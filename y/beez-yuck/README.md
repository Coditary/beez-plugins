# yuck

Official Eww Yuck plugin — validate `eww.yuck` and widget configuration.

Plugin ID: **`coditary/yuck`**

## Install

```lua
reqpack { beez = { { name = "coditary/yuck", version = "1.0.0", source = "github:Coditary/beez-yuck" } } }
```

## Usage

```lua
configure({ { "coditary/yuck", {} } })
```

```bash
beez -p compile[yuck]
beez -s yuck:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `yuck` | `eww --version` | Verifies Eww CLI |
| compile | `yuck` | `eww daemon` + `eww ping` | Validates Yuck config loads |
| bundle | `yuck` | verify stamp | Checks validation artifact |
| test | `yuck` | verify `eww.yuck` | Validates widget source files exist |

## Detection

- Markers: `eww.yuck`, `**/*.yuck`, `eww.scss`, `eww.css`
- Entry point: `eww.yuck`, then first non-test `*.yuck`, or `entry_source` in configure()
- Config directory auto-detected from `eww.yuck` location

## License

Apache License 2.0.
