# perl

Official Perl compiler plugin — `perl -c` syntax verification with auto-detected `.pl`/`.pm` targets.

Plugin ID: **`coditary/perl`**

## Install

```lua
reqpack { beez = { { name = "coditary/perl", version = "1.0.0", source = "github:Coditary/beez-perl" } } }
```

## Usage

```lua
configure({ { "coditary/perl", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `cpanm --installdeps .` / `perl Makefile.PL` | From `cpanfile` or `Makefile.PL` |
| compile | `perl -c` on all `.pl`/`.pm` | Writes compile stamp under `build/perl/` |
| bundle | verify compile stamp | Checks `build/perl/.perl-compile-*` |
| test | `prove -l t/` or `make test` | Writes `report/test/perl-*.ok` |

## Detection

- Markers: `cpanfile`, `Makefile.PL`, `**/*.pl`, `**/*.pm`
- Compile targets: all non-test `.pl` and `.pm` files
- Binary: `perl` (override with `PERL` env or `perl_binary` config)

## License

Apache License 2.0.
