# janet

Official Janet compiler — jpm static compile to native executable with auto-detected entry.

Plugin ID: **`coditary/janet`**

## Install

```lua
reqpack { beez = { { name = "coditary/janet", version = "1.0.0", source = "github:Coditary/beez-janet" } } }
```

## Usage

```lua
configure({ { "coditary/janet", {} } })
```

```bash
beez -p compile[janet]
beez -s janet:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `janet` | `jpm -l deps` | Skipped when no `project.janet` |
| compile | `janet` | `jpm build` / `jpm quickbin` | Static native executable |
| bundle | `janet` | verify binary | Checks `build/janet/bin/app` |
| test | `janet` | `jpm -l test` | Requires `project.janet` |

## Detection

- Markers: `project.janet`, `**/*.janet`
- Entry points: `main.janet`, `src/main.janet`, or first non-test `*.janet`
- With `project.janet`: uses `jpm build` for static executables from `declare-executable`
- Without `project.janet`: uses `jpm quickbin` for single-file static compile

## License

Apache License 2.0.
