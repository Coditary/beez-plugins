# brainfuck

Official Brainfuck compiler plugin — `bfc` AOT x86-64 with auto-detected targets.

Plugin ID: **`coditary/brainfuck`**

## Install

```lua
reqpack { beez = { { name = "coditary/brainfuck", version = "1.0.0", source = "github:Coditary/beez-brainfuck" } } }
```

## Usage

```lua
configure({ { "coditary/brainfuck", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[brainfuck]
beez -s coditary/brainfuck:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `bfc` | Creates `build/brainfuck/.brainfuck-setup` |
| compile | `bfc` | Native x86-64 binary under `build/brainfuck/bin/` |
| bundle | verify artifacts | Checks compile outputs |
| test | verify build output | Writes `report/test/brainfuck-*.ok` |

## Detection

- Markers: `**/*.bf`, `**/*.b`
- Entry points: `main.bf`, `main.b`, `app.bf`, `app.b`, or first non-test source
- Compile targets: all non-test source files

## License

Apache License 2.0.
