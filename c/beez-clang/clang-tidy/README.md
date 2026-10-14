# clang-tidy

Incremental clang-tidy lint, analyzer, and security checks

Part of the [Coditary/beez-clang](https://github.com/Coditary/beez-clang) monorepo.

## Install

From the Beez plugin catalog:

```bash
rqp install beez coditary/clang-tidy@1.0.0
```

From this subdirectory via `build.lua`:

```lua
reqpack {
  beez = {
    {
      name = "coditary/clang-tidy",
      version = "1.0.0",
      source = "github:Coditary/beez-clang#clang-tidy",
    },
  },
}
```
