# buildah

Official Buildah plugin — build OCI container images from Containerfile or Dockerfile with auto-detection.

Plugin ID: **`coditary/buildah`**

## Install

```lua
reqpack { beez = { { name = "coditary/buildah", version = "1.0.0", source = "github:Coditary/beez-buildah" } } }
```

## Usage

```lua
configure({ { "coditary/buildah", {} } })
```

```bash
beez -p compile[buildah]
beez -s buildah:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `buildah` | `buildah --version` | Verifies Buildah CLI and containerfile |
| compile | `buildah` | `buildah bud -f <file> -t <tag> .` | Builds OCI image |
| bundle | `buildah` | `buildah inspect <tag>` | Verifies image exists |
| test | `buildah` | `buildah inspect --format` | Inspects image metadata |

## Detection

- Markers: `Containerfile`, `Dockerfile`, `**/Containerfile`, `**/Dockerfile`
- Prefers `Containerfile` over `Dockerfile`, or `containerfile` in configure()
- Default tag: `beez-build:latest` (override via `image_tag`)

## License

Apache License 2.0.
