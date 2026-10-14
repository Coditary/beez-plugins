# jikes

**IBM Jikes** Java compiler plugin for Beez — compiles `**/*.java` sources into `build/jikes/`.

Plugin ID: **`coditary/jikes`**

> **Legacy notice:** [Jikes](https://en.wikipedia.org/wiki/Jikes) is a historical open-source Java compiler from IBM, last released in 2004. It targets older Java language levels and is maintained here for legacy codebases, research, and toolchain archaeology. For modern Java projects, use `javac`, Eclipse ECJ, or a build tool such as Maven or Gradle instead.

## Install

```lua
reqpack { beez = { { name = "coditary/jikes", version = "1.0.0", source = "github:Coditary/beez-jikes" } } }
```

Local development:

```lua
reqpack { beez = { { name = "coditary/jikes", path = ".", version = "1.0.0" } } }
```

Then: `beez --install`

## Usage

```lua
configure({
    { "coditary/jikes", {
        classpath = "lib/junit.jar:lib/hamcrest.jar", -- optional, for tests
    }},
})
```

```bash
beez -p setup[jikes]
beez -p compile[jikes]
beez -p bundle[jikes]
beez -p test[jikes]
```

Or invoke individual steps:

```bash
beez -s coditary/jikes:compile:code
beez -s jikes:compile:code
```

## Steps

| Step | Phase | Scope | Output |
|------|-------|-------|--------|
| `configure:setup` | setup | jikes | `build/jikes/.jikes-setup` |
| `compile:code` | compile | jikes | `build/jikes/classes/**`, `build/jikes/app.jar` |
| `bundle:code` | bundle | jikes | `build/jikes/app.jar` |
| `test:unit` | test | jikes | `report/test/jikes-code.ok` |

Debug variants (`configure:debug`, `compile:debug`, …) compile with `-g` debug symbols.

## Requirements

- **`jikes`** on `PATH` (the IBM Jikes binary)
- **`jar`** and **`java`** for bundle and test steps
- **JUnit** on the classpath when running tests (`classpath` / `test_classpath` config)

## Auto-detection

Sources are discovered via `ctx.glob({ "**/*.java" })`. Files matching `*Test.java` or under `test/` are treated as test sources. The default source root is `src/` when present.

## License

Apache License 2.0.
