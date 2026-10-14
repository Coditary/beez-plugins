# jython

Official Jython JVM Python compiler plugin — `jython -m compileall` with auto-detected `*.py` targets.

Plugin ID: **`coditary/jython`**

## Install

```lua
reqpack { beez = { { name = "coditary/jython", version = "1.0.0", source = "github:Coditary/beez-jython" } } }
```

## Usage

```lua
configure({ { "coditary/jython", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[jython]
beez -s coditary/jython:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `jython` and `java` | Creates `build/jython/.jython-setup` |
| compile | `jython -m compileall -b` | Compiles Python to JVM bytecode |
| bundle | verify bytecode | Checks `build/jython` for `.class`/`.pyc` |
| test | run primary script | Executes `main.py` or first entry |

## Detection

- Markers: `**/*.py`, optional `jython`/`setup.py`/`requirements.txt`
- Entry points: `main.py`, or first non-test script
- Binaries: `jython`, `java` (override with `JYTHON`/`JAVA` env)

## License

Apache License 2.0.
