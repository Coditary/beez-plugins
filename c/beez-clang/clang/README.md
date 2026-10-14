# clang

Clang compile and link steps from compile_commands.json

Part of the [Coditary/beez-clang](https://github.com/Coditary/beez-clang) monorepo.

## Install

From the Beez plugin catalog:

```bash
rqp install beez coditary/clang@1.0.0
```

From this subdirectory via `build.lua`:

```lua
reqpack {
  beez = {
    {
      name = "coditary/clang",
      version = "1.0.0",
      source = "github:Coditary/beez-clang#clang",
    },
  },
}
```
