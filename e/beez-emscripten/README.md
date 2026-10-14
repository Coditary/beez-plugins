# emscripten

Emscripten compile, link, and test steps from `compile_commands.json` — C/C++ to WebAssembly via LLVM (`emcc` / `em++`).

## Install

From the Beez plugin catalog:

```bash
rqp install beez coditary/emscripten@1.0.0
```

From this directory via `build.lua`:

```lua
reqpack {
  beez = {
    {
      name = "coditary/emscripten",
      version = "1.0.0",
      path = ".",
    },
  },
}
```

Then: `beez --install`

## Usage

Requires a configured CMake/Conan build tree with `compile_commands.json` under `build/emscripten/wasm/`.

```bash
beez wasm                              # setup → compile → bundle → test
beez -s coditary/emscripten:emscripten:setup
beez -s coditary/emscripten:emscripten:compile
beez -p compile[wasm]
```

Set `CC=emcc` and `CXX=em++` (defaults) to override the compiler binaries used when replaying commands. Compile commands are normalized to use `-O3`.

## Steps

| Step | Phase | Scope | Description |
|------|-------|-------|-------------|
| `emscripten:setup` | setup | wasm | Prepare build tree and verify emcc/em++ |
| `emscripten:compile` | compile | wasm | Compile sources from compile_commands.json |
| `emscripten:bundle` | bundle | wasm | Link Wasm/JS artifacts |
| `emscripten:test` | test | wasm | Run ctest in the Wasm build tree |

## Output

Artifacts are written under `build/emscripten/wasm/` (`.wasm`, `.js`, `.html`).

## License

Apache-2.0 — see [LICENSE](LICENSE).
