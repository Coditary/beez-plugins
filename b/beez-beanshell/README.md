# beanshell

**BeanShell** — Java scripting with JRE and `bsh.jar` for `.bsh` sources.

Plugin ID: **`coditary/beanshell`**

## Install

```lua
reqpack { beez = { { name = "coditary/beanshell", version = "1.0.0", source = "github:Coditary/beez-beanshell" } } }
```

## Usage

```lua
configure({ { "coditary/beanshell", { bsh_jar = "lib/bsh.jar" } } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[beanshell]
beez -s beanshell:compile:code
```

## Detection

| Marker | Toolchain |
|--------|-----------|
| `**/*.bsh` | `java -cp bsh.jar bsh.Interpreter` |

Entry points are inferred from `main.bsh`, `Main.bsh`, or the first non-test `.bsh` file.

Setup verifies `java` and `bsh.jar` (override via `BSH_JAR` env or `bsh_jar` config).

## Output

| Profile | Scope | Output |
|---------|-------|--------|
| Release | `beanshell` | `build/beanshell/bin/*.bsh` |
| Debug | `beanshell` | `build/beanshell/bin/*.bsh` |

## License

Apache License 2.0.
