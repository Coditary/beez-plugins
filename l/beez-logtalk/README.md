# logtalk

Official Logtalk compiler plugin — compile `.lgt` and `.logtalk` sources on SWI-Prolog, auto-detected via `ctx.glob`.

Plugin ID: **`coditary/logtalk`**

## Requirements

- [Logtalk](https://logtalk.org/) 3.x (`logtalk` on PATH)
- [SWI-Prolog](https://www.swi-prolog.org/) (`swipl` on PATH)

## Install

```lua
reqpack { beez = { { name = "coditary/logtalk", version = "1.0.0", source = "github:Coditary/beez-logtalk" } } }
```

## Usage

```lua
configure({ { "coditary/logtalk", {} } })
workflows({ build = "coditary/logtalk:build" })
```

```bash
beez build
beez -p compile[logtalk]
beez -s logtalk:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `logtalk` | Verify `logtalk` and `swipl` toolchains |
| compile | `logtalk` | Compile detected Logtalk sources to `.qlf` |
| bundle | `logtalk` | Verify build artifacts under `build/logtalk/bin/` |
| test | `logtalk` | Run `logtalk --check` on primary source |

## Detection

- Markers: `**/*.lgt`, `**/*.logtalk`
- Entry points: `loader.lgt`, `logtalk.lgt`, `main.lgt`, or first non-test source
- Binaries: `logtalk` (override with `LOGTALK` env), `swipl` (override with `SWIPL` env)

## License

Apache License 2.0.
