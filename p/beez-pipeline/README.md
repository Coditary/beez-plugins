# pipeline

Standard staged workflows (build, quality, coverage, fuzz, standard, …)

Standalone Beez workflow plugin published by **coditary**.

## Install

From the Beez plugin catalog (after release packaging):

```bash
rqp install beez coditary/pipeline@1.0.0
```

From this repository (git source):

```bash
# build.lua
reqpack { beez = { { name = "coditary/pipeline", version = "1.0.0", source = "github:Coditary/beez-pipeline" } } }
```

```bash
beez --install
```

Local development:

```bash
reqpack { beez = { { name = "coditary/pipeline", path = ".", version = "1.0.0" } } }
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
  --name pipeline \
  --version 1.0.0 \
  --source-dir . \
  --platform linux \
  --arch x86_64 \
  --output-dir dist
```

## Metadata

| Field | Value |
|-------|-------|
| Plugin ID | `coditary/pipeline` |
| Version | `1.0.0` |
| Suggested repo | `Coditary/beez-pipeline` |
| Maintainer | Leonard Ramminger <Matographo@gmail.com> |

## License

Apache License 2.0. See [LICENSE](LICENSE).
