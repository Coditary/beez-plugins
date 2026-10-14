# bazel

Official Bazel plugin — build and test monorepo targets from BUILD and WORKSPACE files.

Plugin ID: **`coditary/bazel`**

## Install

```lua
reqpack { beez = { { name = "coditary/bazel", version = "1.0.0", source = "github:Coditary/beez-bazel" } } }
```

## Usage

```lua
configure({ { "coditary/bazel", {} } })
```

```bash
beez -p compile[bazel]
beez -s bazel:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `bazel` | `bazel info workspace` | Verifies CLI and workspace |
| compile | `bazel` | `bazel build //...` | Builds all targets |
| bundle | `bazel` | verify stamp | Checks build.ok in `build/bazel/bin/` |
| test | `bazel` | `bazel test //...` | Runs Bazel test targets |

## Detection

- Markers: `BUILD`, `BUILD.bazel`, `WORKSPACE`, `WORKSPACE.bazel`, `**/BUILD`, `**/BUILD.bazel`
- Entry point: root `WORKSPACE`/`MODULE.bazel`, then root `BUILD`, or `entry_source` in configure()

## License

Apache License 2.0.
