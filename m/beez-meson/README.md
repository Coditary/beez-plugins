# meson

Official Meson plugin — configure and compile meson.build meta-build projects.

Plugin ID: **`coditary/meson`**

## Install

```lua
reqpack { beez = { { name = "coditary/meson", version = "1.0.0", source = "github:Coditary/beez-meson" } } }
```

## Usage

```lua
configure({ { "coditary/meson", {} } })
```

```bash
beez -p compile[meson]
beez -s meson:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `meson` | `meson setup build/meson` | Verifies CLI and configures build |
| compile | `meson` | `meson compile -C build/meson` | Builds all targets |
| bundle | `meson` | verify stamp | Checks build.ok in `build/meson/bin/` |
| test | `meson` | `meson test -C build/meson` | Runs Meson test suite |

## Detection

- Markers: `meson.build`, `**/meson.build`
- Entry point: shallowest non-test `meson.build`, or `entry_source` in configure()
- Source directory: parent directory of the detected manifest

## License

Apache License 2.0.
