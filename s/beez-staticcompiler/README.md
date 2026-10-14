# staticcompiler

Julia **StaticCompiler.jl** plugin — compile standalone native binaries without a full Julia runtime.

Plugin ID: **`coditary/staticcompiler`**

> **Community project:** This plugin wraps [StaticCompiler.jl](https://github.com/tshort/StaticCompiler.jl) by [tshort](https://github.com/tshort), an experimental community package. Static compilation has substantial limitations compared to regular Julia code (no GC allocations, restricted types). See [StaticTools.jl](https://github.com/brenhinkeller/StaticTools.jl) for helper utilities.

## Install

```lua
reqpack { beez = { { name = "coditary/staticcompiler", version = "1.0.0", source = "github:Coditary/beez-staticcompiler" } } }
```

## Usage

```lua
configure({ { "coditary/staticcompiler", {} } })
```

```bash
beez -s staticcompiler:configure:setup
beez -p compile[static]          # compile_executable → build/staticcompiler/bin/
beez -s staticcompiler:compile:shlib
beez -p bundle[static]
beez -p test[test]
```

## Requirements

- Julia with [StaticCompiler.jl](https://github.com/tshort/StaticCompiler.jl) available (`julia -e 'using StaticCompiler'`)
- Julia project with `Project.toml`, entry script (`src/<Package>.jl`), and a top-level entry function (default: `main`)

## Compile modes

| Step | API | Output |
|------|-----|--------|
| `compile:static` | `StaticCompiler.compile_executable` | `build/staticcompiler/bin/<name>` |
| `compile:shlib` | `StaticCompiler.compile_shlib` | `build/staticcompiler/bin/lib<name>.{so,dylib,dll}` |

## Configuration

```lua
configure({
  { "coditary/staticcompiler", {
    entry_script = "src/MyApp.jl",
    entry_function = "main",
    arg_types = "()",
    output_name = "myapp",
    cflags = "-lm",
  }},
})
```

## License

Apache License 2.0.
