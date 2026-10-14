# clang-format

Incremental clang-format check and apply

Part of the [Coditary/beez-clang](https://github.com/Coditary/beez-clang) monorepo.

## Install

From the Beez plugin catalog:

```bash
rqp install beez coditary/clang-format@1.0.0
```

From this subdirectory via `build.lua`:

```lua
reqpack {
  beez = {
    {
      name = "coditary/clang-format",
      version = "1.0.0",
      source = "github:Coditary/beez-clang#clang-format",
    },
  },
}
```
