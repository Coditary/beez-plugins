# mock

Official Fedora Mock plugin — build RPM packages in isolated chroots.

Plugin ID: **`coditary/mock`**

## Install

```lua
reqpack { beez = { { name = "coditary/mock", version = "1.0.0", source = "github:Coditary/beez-mock" } } }
```

## Usage

```lua
configure({ { "coditary/mock", { mock_config = "fedora-rawhide-x86_64" } } })
```

```bash
beez -p compile[mock]
beez -s mock:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `mock` | `mock --version` | Verifies Mock and config |
| compile | `mock` | `mock -r <config> spec` | Chroot RPM build |
| bundle | `mock` | verify resultdir | Checks build stamp and output |
| test | `mock` | verify spec + config | Validates Mock setup |

## Detection

- Markers: `**/*.spec`, `mock.cfg`, `site-defaults.cfg`
- Entry point: first non-test `*.spec`, or `entry_source` in configure()
- Mock chroot: `mock_config` (default `fedora-rawhide-x86_64`)

## License

Apache License 2.0.
