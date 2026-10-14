# sqlboiler

Official SQLBoiler plugin — generate Go ORM models from `sqlboiler.toml` with auto-detection.

Plugin ID: **`coditary/sqlboiler`**

## Install

```lua
reqpack { beez = { { name = "coditary/sqlboiler", version = "1.0.0", source = "github:Coditary/beez-sqlboiler" } } }
```

## Usage

```lua
configure({ { "coditary/sqlboiler", {} } })
```

```bash
beez -p compile[sqlboiler]
beez -s sqlboiler:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `sqlboiler` | `sqlboiler --version` | Verifies SQLBoiler CLI and config |
| compile | `sqlboiler` | `sqlboiler psql --config <toml>` | Generates Go models |
| bundle | `sqlboiler` | verify models dir | Checks generated packages |
| test | `sqlboiler` | `go build ./models/...` | Builds generated packages |

## Detection

- Markers: `sqlboiler.toml`, `go.mod`
- Config: shallowest `sqlboiler.toml`, or `config_path` in configure()
- Default driver: `psql` (override via `db_driver`)

## License

Apache License 2.0.
