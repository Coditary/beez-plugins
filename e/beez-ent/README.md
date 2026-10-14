# ent

Official Facebook Ent plugin — generate Go ORM code from `ent/schema` with auto-detection.

Plugin ID: **`coditary/ent`**

## Install

```lua
reqpack { beez = { { name = "coditary/ent", version = "1.0.0", source = "github:Coditary/beez-ent" } } }
```

## Usage

```lua
configure({ { "coditary/ent", {} } })
```

```bash
beez -p compile[ent]
beez -s ent:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `ent` | `go version` + verify schema dir | Verifies Go toolchain |
| compile | `ent` | `go run entgo.io/ent/cmd/ent generate` | Generates Ent code |
| bundle | `ent` | verify output dir | Checks generated packages |
| test | `ent` | `go build ./ent/...` | Builds generated packages |

## Detection

- Markers: `ent/schema/**/*.go`, `go.mod`
- Schema dir: auto-detected from `ent/schema/**/*.go`, or `ent_schema_dir` in configure()

## License

Apache License 2.0.
