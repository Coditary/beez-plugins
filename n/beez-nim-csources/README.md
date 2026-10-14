# nim-csources

Nim bootstrap via csources — build the C bootstrap compiler with GCC/Clang, then bootstrap the full Nim compiler with `koch`.

Plugin ID: **`coditary/nim-csources`**

## Install

```lua
reqpack { beez = { { name = "coditary/nim-csources", version = "1.0.0", source = "github:Coditary/beez-nim-csources" } } }
```

## Usage

```lua
configure({ { "coditary/nim-csources", { cc_binary = "clang" } } })
workflows({ build = "coditary/nim-csources:build" })
```

```bash
beez build
beez -p setup[csources]
beez -p compile[csources]
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `CC=gcc sh csources_v3/build.sh` | Or run `build_nim.sh` when present |
| compile | `nim_csources c koch && koch boot` | Bootstraps full compiler to `build/nim-csources/bin/nim` |
| bundle | verify binaries | Checks bootstrap + bootstrapped `nim` |
| test | `koch test` or smoke test | Falls back to `nim --version` |

## Detection

- Markers: `compiler/nim.nim`, `**/*.nim`, `build_nim.sh`
- Csources dirs: `csources_v3`, `csources_v2`, `csources_v1`, `csources` (first with `build.sh`)
- Output: `build/nim-csources/bin/nim_csources` (bootstrap) and `build/nim-csources/bin/nim` (bootstrapped)

## License

Apache License 2.0.
