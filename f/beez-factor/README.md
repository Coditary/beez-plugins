# factor

Official Factor compiler plugin — Factor with auto-detected source targets.

Plugin ID: **`coditary/factor`**

## Install

```lua
reqpack { beez = { { name = "coditary/factor", version = "1.0.0", source = "github:Coditary/beez-factor" } } }
```

## Usage

```lua
configure({ { "coditary/factor", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[factor]
beez -s factor:compile
```

## Steps

| Phase | Tool | Notes |
|-------|------|-------|
| setup | `factor` | Verify compiler and prepare `build/factor/` |
| compile | `factor` | Validate via `factor -run=<script.factor>`. |
| bundle | verify artifacts | Checks outputs under `build/factor/` |
| test | `prove -l t/` | Writes `report/test/factor-*.ok` |

## Detection

- Markers: `**/*.factor`
- Scope: `factor`
- Binary: `factor` (override with `FACTOR` env or `factor_binary` config)

## License

Apache License 2.0.
