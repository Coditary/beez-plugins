# z88dk

Official z88dk Z80 cross-compiler — `zcc` for C to Z80 targets with auto-detected `*.c` entry.

Plugin ID: **`coditary/z88dk`**

## Install

```lua
reqpack { beez = { { name = "coditary/z88dk", version = "1.0.0", source = "github:Coditary/beez-z88dk" } } }
```

## Usage

```lua
configure({ { "coditary/z88dk", { z88dk_target = "+cpm" } } })
```

```bash
beez -p compile[z88dk]
beez -s z88dk:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `z88dk` | `zcc +zx -h` | Verifies z88dk zcc binary |
| compile | `z88dk` | `zcc +target -O2 main.c -o app -create-app` | Z80 binary via zcc |
| bundle | `z88dk` | verify binary | Checks `.bin`/`.tap` output |
| test | `z88dk` | `zcc` on test sources | Skipped when no test files are detected |

## Detection

- Markers: `**/*.c`
- Entry points: `main.c`, `src/main.c`, or first root `*.c`
- Tests: `**/*_test.c`, `test/**/*.c`, `tests/**/*.c`
- Default target: `+zx` (override via `z88dk_target` in configure)

## License

Apache License 2.0.
