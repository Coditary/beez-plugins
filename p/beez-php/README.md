# php

Official PHP Zend Engine compiler — `php -l` syntax check plus OPcache bytecode with Composer and PHPUnit.

Plugin ID: **`coditary/php`**

## Install

```lua
reqpack { beez = { { name = "coditary/php", version = "1.0.0", source = "github:Coditary/beez-php" } } }
```

## Usage

```lua
configure({ { "coditary/php", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `composer install` | Skipped when no `composer.json` |
| compile | `php -l` + OPcache file cache | Output under `build/php/` |
| bundle | verify bytecode | Checks `build/php/.compiled` |
| test | `vendor/bin/phpunit` or `phpunit` | Writes `report/test/php-*.ok` |

## Detection

- Markers: `composer.json`, `**/*.php`
- Entry points: `public/index.php`, `index.php`, or first non-test `*.php`
- Binary: `php` (override with `PHP` env or `php_binary` config)

## License

Apache License 2.0.
