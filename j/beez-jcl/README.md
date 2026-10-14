# jcl

IBM JCL — mainframe job control language for `*.jcl` job streams.

Plugin ID: **`coditary/jcl`**

## Install

```lua
reqpack { beez = { { name = "coditary/jcl", version = "1.0.0", source = "github:Coditary/beez-jcl" } } }
```

## Usage

```lua
configure({ { "coditary/jcl", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[jcl]
beez -s jcl:compile
```

## Steps

| Phase | Step | Notes |
|-------|------|-------|
| setup | `configure:setup` / `configure:debug` | Verify `jcl` job processor |
| compile | `compile:code` / `compile:debug` | Validate and package JCL job streams |
| bundle | `bundle:code` / `bundle:debug` | Verify build artifacts |
| test | `test:unit` / `test:debug` | Writes `report/test/jcl-*.ok` |

## Detection

- Markers: `**/*.jcl`
- Entry points: `main.jcl`, `job.jcl`, or first non-test source file
- Requires a JCL validator/submitter on `PATH` (default: `jcl`, override via `JCL` env)

## License

Apache License 2.0.
