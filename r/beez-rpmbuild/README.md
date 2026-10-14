# rpmbuild

Official RPM build plugin — build packages from spec files with rpmbuild.

Plugin ID: **`coditary/rpmbuild`**

## Install

```lua
reqpack { beez = { { name = "coditary/rpmbuild", version = "1.0.0", source = "github:Coditary/beez-rpmbuild" } } }
```

## Usage

```lua
configure({ { "coditary/rpmbuild", {} } })
```

```bash
beez -p compile[rpmbuild]
beez -s rpmbuild:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `rpmbuild` | `rpmbuild --version` | Prepares RPM topdir |
| compile | `rpmbuild` | `rpmbuild -ba` | Builds binary and source RPMs |
| bundle | `rpmbuild` | verify RPMS dir | Checks build stamp and output |
| test | `rpmbuild` | `rpmbuild -bp` | Prep-only spec validation |

## Detection

- Markers: `**/*.spec`
- Entry point: first non-test `*.spec`, or `entry_source` in configure()

## License

Apache License 2.0.
