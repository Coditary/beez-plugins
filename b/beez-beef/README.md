# beef

Official Beef compiler — `beefc` LLVM backend with auto-detected `BeefProj.toml` layout.

Plugin ID: **`coditary/beef`**

## Install

```lua
reqpack { beez = { { name = "coditary/beef", version = "1.0.0", source = "github:Coditary/beez-beef" } } }
```

## Usage

```lua
configure({ { "coditary/beef", {} } })
```

```bash
beez -p compile[beef]
beez -s beef:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `beef` | `beefc -version` | Verifies Beef compiler binary |
| compile | `beef` | `BeefBuild` / `beefc -out` | Project or single-file build |
| bundle | `beef` | verify binary | Checks `build/beef/bin/app` |
| test | `beef` | `BeefBuild -test` | Skipped when no test files are detected |

## Detection

- Markers: `BeefProj.toml`, `**/*.bf`
- Entry points: `src/main.bf`, `main.bf`, or first root `*.bf`
- Tests: `tests/**/*.bf`, `test/**/*.bf`, `*_test.bf`

## License

Apache License 2.0.
