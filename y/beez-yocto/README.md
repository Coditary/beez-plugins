# yocto

Official Yocto/OpenEmbedded plugin — parse and validate BitBake recipes with `conf/local.conf` auto-detection.

Plugin ID: **`coditary/yocto`**

## Install

```lua
reqpack { beez = { { name = "coditary/yocto", version = "1.0.0", source = "github:Coditary/beez-yocto" } } }
```

## Usage

```lua
configure({ { "coditary/yocto", {} } })
```

```bash
beez -p compile[yocto]
beez -s yocto:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `yocto` | `bitbake --version` + verify `conf/local.conf` | Verifies BitBake CLI |
| compile | `yocto` | `bitbake -p <target>` | Parses recipes and validates build environment |
| bundle | `yocto` | verify parse stamp | Checks build artifacts |
| test | `yocto` | `bitbake -p` | Validates recipe syntax |

## Detection

- Markers: `conf/local.conf`, `**/*.bb`, `**/*.bbappend`
- Entry point: first `*.bb` recipe, or `entry_recipe` in configure()
- Default target: `core-image-minimal` (override via `bb_target`)

## License

Apache License 2.0.
