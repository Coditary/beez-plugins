# cmake

Official CMake plugin — configure and build CMakeLists.txt meta-build projects.

Plugin ID: **`coditary/cmake`**

## Install

```lua
reqpack { beez = { { name = "coditary/cmake", version = "1.0.0", source = "github:Coditary/beez-cmake" } } }
```

## Usage

```lua
configure({ { "coditary/cmake", {} } })
```

```bash
beez -p compile[cmake]
beez -s cmake:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `cmake` | `cmake -S . -B build/cmake` | Verifies CLI and configures build |
| compile | `cmake` | `cmake --build build/cmake` | Builds all targets |
| bundle | `cmake` | verify stamp | Checks build.ok in `build/cmake/bin/` |
| test | `cmake` | `ctest --test-dir build/cmake` | Runs CTest suite |

## Detection

- Markers: `CMakeLists.txt`, `**/CMakeLists.txt`
- Entry point: shallowest non-test `CMakeLists.txt`, or `entry_source` in configure()
- Source directory: parent directory of the detected manifest

## License

Apache License 2.0.
