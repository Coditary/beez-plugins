# luajit

Official LuaJIT compiler — `luajit -b` bytecode or direct run with auto-detected targets.

Plugin ID: **`coditary/luajit`**

## Install

```lua
reqpack { beez = { { name = "coditary/luajit", version = "1.0.0", source = "github:Coditary/beez-luajit" } } }
```

## Usage

```lua
configure({ { "coditary/luajit", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[luajit]
beez -s coditary/luajit:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `luajit` | Creates `build/luajit/.luajit-setup` |
| compile | `luajit -b` or direct run | Output under `build/luajit/` |
| bundle | verify artifacts | Checks bytecode or validation stamps |
| test | `luajit` run | Executes bytecode or source |

## Profiles

| Profile | Mode | Compile |
|---------|------|---------|
| `code` | bytecode | `luajit -bs -b source build/luajit/app.luac` |
| `debug` | run | load check + direct `luajit source` |

## Detection

- Markers: `**/*.lua`
- Entry points: `main.lua`, `src/main.lua`, or first non-test `*.lua`

## License

Apache License 2.0.
