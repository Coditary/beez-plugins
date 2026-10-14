# jsc

JavaScriptCore (WebKit JS engine) — `jsc -b` bytecode compile, auto-detected JavaScript projects.

Plugin ID: **`coditary/jsc`**

## Install

```lua
reqpack { beez = { { name = "coditary/jsc", version = "1.0.0", source = "github:Coditary/beez-jsc" } } }
```

## Usage

```lua
configure({ { "coditary/jsc", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[jsc]
beez -s jsc:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `command -v jsc`, `npm install` | npm skipped when no `package.json` |
| compile | `jsc -b` | Bytecode under `build/jsc/dist/` |
| bundle | verify dist | Checks `build/jsc/dist/**` |
| test | `npm test` or `jsc <entry>` | npm when `package.json` exists |

## Detection

- Markers: `package.json`, `**/*.js`
- Entry points: `src/index.js`, `src/main.js`, or first `src/*.js`

## License

Apache License 2.0.
