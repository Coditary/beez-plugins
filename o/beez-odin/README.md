# odin

Official Odin compiler — `odin build` with auto-detected `build.odin` project layout.

Plugin ID: **`coditary/odin`**

## Install

```lua
reqpack { beez = { { name = "coditary/odin", version = "1.0.0", source = "github:Coditary/beez-odin" } } }
```

## Usage

```lua
configure({ { "coditary/odin", {} } })
```

```bash
beez -p compile[odin]
beez -s odin:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `odin` | `odin version` | Verifies Odin compiler binary |
| compile | `odin` | `odin build . -out:build/odin/bin/app` | Native binary output |
| bundle | `odin` | verify binary | Checks `build/odin/bin/app` |
| test | `odin` | `odin test` | Skipped when no test files are detected |

## Detection

- Markers: `build.odin`, `**/*.odin`
- Tests: `tests/**/*.odin`, `test/**/*.odin`, `*_test.odin`

## License

Apache License 2.0.
