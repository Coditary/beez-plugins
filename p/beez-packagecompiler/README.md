# packagecompiler

Julia **PackageCompiler.jl** AOT compiler — `create_app` and `create_sysimage` with auto-detected `Project.toml`.

Plugin ID: **`coditary/packagecompiler`**

## Install

```lua
reqpack { beez = { { name = "coditary/packagecompiler", version = "1.0.0", source = "github:Coditary/beez-packagecompiler" } } }
```

## Usage

```lua
configure({ { "coditary/packagecompiler", {} } })
```

```bash
beez -s packagecompiler:configure:setup
beez -p compile[aot]          # create_app → build/packagecompiler/bin/
beez -s packagecompiler:compile:sysimage
beez -p bundle[aot]
beez -p test[test]
```

## Requirements

- Julia with [PackageCompiler.jl](https://github.com/JuliaLang/PackageCompiler.jl) available (`julia -e 'using PackageCompiler'`)
- Julia project with `Project.toml` and entry script (`src/<Package>.jl`)

## Compile modes

| Step | API | Output |
|------|-----|--------|
| `compile:app` | `PackageCompiler.create_app` | `build/packagecompiler/bin/<name>` |
| `compile:sysimage` | `PackageCompiler.create_sysimage` | `build/packagecompiler/bin/sysimage.{so,dylib,dll}` |

## Configuration

```lua
configure({
  { "coditary/packagecompiler", {
    entry_script = "src/MyApp.jl",
    output_name = "myapp",
    precompile_execution_file = { "precompile.jl" },
  }},
})
```

## License

Apache License 2.0.
