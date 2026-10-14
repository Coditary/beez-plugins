# ceu

Céu language — reactive language compiler for `.ceu` sources.

Plugin ID: **`coditary/ceu`**

## Install

```lua
reqpack { beez = { { name = "coditary/ceu", version = "1.0.0", source = "github:Coditary/beez-ceu" } } }
```

## Usage

```lua
configure({ { "coditary/ceu", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[ceu]
beez -s ceu:compile
```

## Steps

| Phase | Step | Notes |
|-------|------|-------|
| setup | `configure:setup` / `configure:debug` | Verify `ceu` binary |
| compile | `compile:code` / `compile:debug` | Compile to native binary or generate C |
| bundle | `bundle:code` / `bundle:debug` | Verify build artifacts |
| test | `test:unit` / `test:debug` | Writes `report/test/ceu-*.ok` |

## Detection

- Markers: `**/*.ceu`
- Entry points: `main.ceu`, `src/main.ceu`, or first non-test source file
- Release profile: `ceu file.ceu --cc --cc-output=...`; debug profile: `ceu --output file.c`

## License

Apache License 2.0.
