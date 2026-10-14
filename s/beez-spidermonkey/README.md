# spidermonkey

Mozilla SpiderMonkey JavaScript JIT engine — `js`/`mozjs` compile and run with auto-detected targets.

Plugin ID: **`coditary/spidermonkey`**

## Install

```lua
reqpack { beez = { { name = "coditary/spidermonkey", version = "1.0.0", source = "github:Coditary/beez-spidermonkey" } } }
```

## Usage

```lua
configure({ { "coditary/spidermonkey", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[spidermonkey]
beez -s coditary/spidermonkey:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `js` or `mozjs` | Creates `build/spidermonkey/.spidermonkey-setup` |
| compile | `js -c -f` or direct run | Output under `build/spidermonkey/` |
| bundle | verify artifacts | Checks compiled JS or validation stamps |
| test | `js -f` | Runs test files or compiled output |

## Profiles

| Profile | Mode | Compile |
|---------|------|---------|
| `code` | compile | `js -c -f source build/spidermonkey/app.js` |
| `debug` | run | direct `js -f source` + validation stamp |

## Detection

- Markers: `**/*.js`
- Entry points: `index.js`, `main.js`, `src/index.js`, or first non-test `*.js`

## License

Apache License 2.0.
