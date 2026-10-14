# ninja

Official Ninja plugin — build projects from build.ninja manifests.

Plugin ID: **`coditary/ninja`**

## Install

```lua
reqpack { beez = { { name = "coditary/ninja", version = "1.0.0", source = "github:Coditary/beez-ninja" } } }
```

## Usage

```lua
configure({ { "coditary/ninja", {} } })
```

```bash
beez -p compile[ninja]
beez -s ninja:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `ninja` | `ninja --version` + targets query | Verifies CLI and build.ninja |
| compile | `ninja` | `ninja -C <dir>` | Builds all targets |
| bundle | `ninja` | verify stamp | Checks build.ok in `build/ninja/bin/` |
| test | `ninja` | `ninja test` or dry-run | Runs test targets when present |

## Detection

- Markers: `build.ninja`, `**/build.ninja`
- Entry point: shallowest non-test `build.ninja`, or `entry_source` in configure()
- Build directory: parent directory of the detected manifest

## License

Apache License 2.0.
