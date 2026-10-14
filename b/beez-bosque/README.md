# bosque

Microsoft Bosque — Node.js compiler for `.bsq` sources.

Plugin ID: **`coditary/bosque`**

## Install

```lua
reqpack { beez = { { name = "coditary/bosque", version = "1.0.0", source = "github:Coditary/beez-bosque" } } }
```

## Usage

```lua
configure({ { "coditary/bosque", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[bosque]
beez -s bosque:compile
```

## Steps

| Phase | Step | Notes |
|-------|------|-------|
| setup | `configure:setup` / `configure:debug` | Verify Node.js, `npm install` if `package.json` |
| compile | `compile:code` / `compile:debug` | Build executable via `bosque build` or `exegen.js` |
| bundle | `bundle:code` / `bundle:debug` | Verify build artifacts |
| test | `test:unit` / `test:debug` | Run `bosque test` or writes ok stamp |

## Detection

- Markers: `**/*.bsq`, `package.json`
- Entry points: `main.bsq`, `src/main.bsq`, or first non-test source file
- Package mode uses `bosque build` / `bosque test`; standalone mode uses `node exegen.js`

## License

Apache License 2.0.
