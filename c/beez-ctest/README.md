# ctest

CTest suite runs for unit, integration, coverage, and sanitizer workflows

Standalone Beez workflow plugin published by **coditary**.

## Install

From the Beez plugin catalog (after release packaging):

```bash
rqp install beez coditary/ctest@1.0.0
```

From this repository (git source):

```bash
# build.lua
reqpack { beez = { { name = "coditary/ctest", version = "1.0.0", source = "github:Coditary/beez-ctest" } } }
```

```bash
beez --install
```

Local development:

```bash
reqpack { beez = { { name = "coditary/ctest", path = ".", version = "1.0.0" } } }
```

## Layout

```
beez.package.json
beez_plugin.lua
src/
scripts/   # optional helper scripts
```

## Package

Build a `.rqp` from the Beez monorepo packaging scripts:

```bash
lua scripts/ci/package_beez_plugin.lua \
  --organization coditary \
  --name ctest \
  --version 1.0.0 \
  --source-dir . \
  --platform linux \
  --arch x86_64 \
  --output-dir dist
```

## Metadata

| Field | Value |
|-------|-------|
| Plugin ID | `coditary/ctest` |
| Version | `1.0.0` |
| Suggested repo | `Coditary/beez-ctest` |
| Maintainer | Leonard Ramminger <Matographo@gmail.com> |

## License

Apache License 2.0. See [LICENSE](LICENSE).
