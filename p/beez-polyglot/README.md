# polyglot

Auto-detect project languages and orchestrate polyglot builds.

Standalone Beez workflow plugin published by **coditary**.

## The idea

Beez compiler plugins share **standard phases and scopes**. When you load multiple language plugins, Beez automatically runs all matching steps in parallel:

```
beez polyglot
  → setup[app]    → conan configure + go mod download + cargo fetch  (parallel)
  → compile[app]  → clang compile + go build + cargo build          (parallel)
  → bundle[app]   → clang link + go verify + cargo verify            (parallel)
  → test[test]    → ctest + go test + cargo test                     (parallel)
```

No special wiring needed — just load the right plugins.

## Install

```lua
reqpack {
    beez = {
        -- Orchestration
        { name = "coditary/polyglot", version = "1.0.0" },
        { name = "coditary/pipeline", version = "1.0.0" },

        -- Load only what your project needs (or all for polyglot):
        { name = "coditary/go",    version = "1.0.0" },
        { name = "coditary/cargo", version = "1.0.0" },
        { name = "coditary/conan", version = "1.0.0" },
        { name = "coditary/clang", version = "1.0.0" },
        { name = "coditary/ctest", version = "1.0.0" },
    },
}
```

## Minimal polyglot `build.lua`

```lua
reqpack {
    beez = {
        { name = "coditary/polyglot", version = "1.0.0" },
        { name = "coditary/go",       version = "1.0.0" },
        { name = "coditary/cargo",    version = "1.0.0" },
        { name = "coditary/conan",    version = "1.0.0" },
        { name = "coditary/clang",    version = "1.0.0" },
        { name = "coditary/ctest",    version = "1.0.0" },
    },
}

workflows({
    polyglot       = "coditary/polyglot:polyglot",
    polyglot_all   = "coditary/polyglot:polyglot_all",
    polyglot_quick = "coditary/polyglot:polyglot_quick",
})

configure({
    { "coditary/go",    {} },
    { "coditary/cargo", {} },
    { "coditary/conan", {} },
    { "coditary/clang", {} },
})
```

```bash
beez detect          # scan project, print detected languages
beez polyglot        # detect → setup → compile → bundle → test
beez polyglot_quick  # compile + test only
beez polyglot_all    # full CI across all languages
```

## Language detection

The `polyglot:detect` step scans for:

| Language | Markers | Plugin |
|----------|---------|--------|
| C++ | `CMakeLists.txt`, `conanfile.py` | `coditary/conan` + `coditary/clang` |
| Go | `go.mod` | `coditary/go` |
| Rust | `Cargo.toml` | `coditary/cargo` |

Output: `report/polyglot/detect.txt`

## Workflows

| Workflow | Description |
|----------|-------------|
| `polyglot` | Detect → setup → compile → bundle → test |
| `polyglot_all` | Full CI with coverage, fuzz, quality, verify |
| `polyglot_quick` | Compile + test only (fast iteration) |
| `polyglot_go` | Go-focused build |
| `polyglot_rust` | Rust-focused build |
| `polyglot_cpp` | C++-focused build |

## Metadata

| Field | Value |
|-------|-------|
| Plugin ID | `coditary/polyglot` |
| Version | `1.0.0` |

## License

Apache License 2.0.
