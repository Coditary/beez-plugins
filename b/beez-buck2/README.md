# buck2

Official Buck2 plugin — build and test Meta Buck2 projects from BUCK and .buckconfig files.

Plugin ID: **`coditary/buck2`**

## Install

```lua
reqpack { beez = { { name = "coditary/buck2", version = "1.0.0", source = "github:Coditary/beez-buck2" } } }
```

## Usage

```lua
configure({ { "coditary/buck2", {} } })
```

```bash
beez -p compile[buck2]
beez -s buck2:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `buck2` | `buck2 root` | Verifies CLI and project root |
| compile | `buck2` | `buck2 build //...` | Builds all targets |
| bundle | `buck2` | verify stamp | Checks build.ok in `build/buck2/bin/` |
| test | `buck2` | `buck2 test //...` | Runs Buck2 test targets |

## Detection

- Markers: `BUCK`, `.buckconfig`, `**/BUCK`
- Entry point: root `.buckconfig`, then shallowest `BUCK`, or `entry_source` in configure()

## License

Apache License 2.0.
