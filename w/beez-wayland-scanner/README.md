# wayland-scanner

Official Wayland protocol scanner plugin — generate C headers and code from protocol XML.

Plugin ID: **`coditary/wayland-scanner`**

## Install

```lua
reqpack { beez = { { name = "coditary/wayland-scanner", version = "1.0.0", source = "github:Coditary/beez-wayland-scanner" } } }
```

## Usage

```lua
configure({ { "coditary/wayland-scanner", {} } })
```

```bash
beez -p compile[wayland-scanner]
beez -s wayland-scanner:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `wayland-scanner` | `wayland-scanner --version` | Verifies scanner binary |
| compile | `wayland-scanner` | `wayland-scanner client-header/public-code …` | Generates C header and code |
| bundle | `wayland-scanner` | verify output | Checks generated artifacts |
| test | `wayland-scanner` | regenerate test header | Validates protocol XML |

## Detection

- Markers: `**/*.xml`
- Entry point: `protocol.xml`, or first non-test XML file, or `entry_source` in configure()
- Output: `protocol-client.h` and `protocol-code.c` (code profile)

## License

Apache License 2.0.
