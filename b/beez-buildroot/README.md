# buildroot

Official Buildroot plugin — embedded Linux builds with defconfig and make.

Plugin ID: **`coditary/buildroot`**

## Install

```lua
reqpack { beez = { { name = "coditary/buildroot", version = "1.0.0", source = "github:Coditary/beez-buildroot" } } }
```

## Usage

```lua
configure({ { "coditary/buildroot", {} } })
```

```bash
beez -p compile[buildroot]
beez -s buildroot:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `buildroot` | `make <defconfig>` | Loads defconfig into .config |
| compile | `buildroot` | `make O=output` | Builds embedded Linux image |
| bundle | `buildroot` | verify output/images | Checks build stamp and artifacts |
| test | `buildroot` | `make printvars` | Validates Buildroot configuration |

## Detection

- Markers: `Config.in`, `**/*defconfig`, `Makefile`
- Entry point: first defconfig, or `defconfig` / `entry_source` in configure()

## License

Apache License 2.0.
