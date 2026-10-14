# hhvm

HipHop Virtual Machine (PHP JIT) — Composer install, `hhvm-autoload`, type-check, and phpunit.

Plugin ID: **`coditary/hhvm`**

## Install

```lua
reqpack { beez = { { name = "coditary/hhvm", version = "1.0.0", source = "github:Coditary/beez-hhvm" } } }
```

## Usage

```lua
configure({ { "coditary/hhvm", {} } })
```

```bash
beez -p setup[hhvm]
beez -p compile[hhvm]
beez -p bundle[hhvm]
beez -p test[test]
```

## Detection

| Marker | Action |
|--------|--------|
| `composer.json` | `composer install` + `hhvm-autoload` |
| `.hhconfig` | Hack project root hint |
| `**/*.php` | Entry points for `hhvm --check` |

Build output: `build/hhvm/`

## License

Apache License 2.0.
