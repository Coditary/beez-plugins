# SQLite SQL

SQLite — in-memory SQL execution for auto-detected *.sql targets

Plugin ID: **`coditary/sqlite`**

## Install

```lua
reqpack { beez = { { name = "coditary/sqlite", version = "1.0.0", source = "github:Coditary/beez-sqlite" } } }
```

## Usage

```lua
configure({ { "coditary/sqlite", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[sqlite]
beez -s coditary/sqlite:compile:code
```

## Detection

- Markers: `**/*.sql`
- Binary: `sqlite3` (override with `SQLITE3` env or config)

## License

Apache License 2.0.
