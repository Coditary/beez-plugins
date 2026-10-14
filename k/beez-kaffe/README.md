# kaffe

**Kaffe** JVM plugin for Beez — compiles `**/*.java` sources with `kaffec` and runs them on the Kaffe virtual machine.

Plugin ID: **`coditary/kaffe`**

> **Legacy notice:** [Kaffe](https://en.wikipedia.org/wiki/Kaffe) is an early free Java virtual machine with a JIT compiler, developed in the 1990s for embedded and open-source use. It targets older Java language levels and is maintained here for legacy codebases, research, and toolchain archaeology. For modern Java projects, use OpenJDK `javac`, Eclipse ECJ, or a build tool such as Maven or Gradle instead.

## Install

```lua
reqpack { beez = { { name = "coditary/kaffe", version = "1.0.0", source = "github:Coditary/beez-kaffe" } } }
```

Local development:

```lua
reqpack { beez = { { name = "coditary/kaffe", path = ".", version = "1.0.0" } } }
```

Then: `beez --install`

## Usage

```lua
configure({
    { "coditary/kaffe", {
        classpath = "lib/junit.jar:lib/hamcrest.jar", -- optional, for tests
    }},
})
```

```bash
beez -p setup[kaffe]
beez -p compile[kaffe]
beez -p bundle[kaffe]
beez -p test[kaffe]
```

Or invoke individual steps:

```bash
beez -s coditary/kaffe:compile:code
beez -s kaffe:compile:code
```

## Steps

| Step | Phase | Scope | Output |
|------|-------|-------|--------|
| `configure:setup` | setup | kaffe | `build/kaffe/.kaffe-setup` |
| `compile:code` | compile | kaffe | `build/kaffe/classes/**`, `build/kaffe/app.jar` |
| `bundle:code` | bundle | kaffe | `build/kaffe/app.jar`, `build/kaffe/bin/run` |
| `test:unit` | test | kaffe | `report/test/kaffe-code.ok` |

Debug variants (`configure:debug`, `compile:debug`, …) compile with `-g` debug symbols.

## Requirements

- **`kaffe`** on `PATH` (the Kaffe JVM runtime)
- **`kaffec`** on `PATH` (the Kaffe Java compiler, bundled with Kaffe)
- **`jar`** for the bundle step
- **JUnit** on the classpath when running tests (`classpath` / `test_classpath` config)

## Auto-detection

Sources are discovered via `ctx.glob({ "**/*.java" })`. Files matching `*Test.java` or under `test/` are treated as test sources. The default source root is `src/` when present.

## License

Apache License 2.0.
