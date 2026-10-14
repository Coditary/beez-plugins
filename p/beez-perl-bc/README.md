# perl-bc

Historical Perl B::C compiler backend — `perl -MO=C,-o` generates C output from Perl sources.

> **Note:** B::C is an experimental/historical Perl compiler backend. It is not maintained for modern Perl versions and should be used for legacy or research purposes only.

Plugin ID: **`coditary/perl-bc`**

## Install

```lua
reqpack { beez = { { name = "coditary/perl-bc", version = "1.0.0", source = "github:Coditary/beez-perl-bc" } } }
```

## Usage

```lua
configure({ { "coditary/perl-bc", {} } })
```

```bash
beez -p compile[perl-bc]
beez -s perl-bc:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `perl` and `B::C` | Prepares `build/perl-bc/` |
| compile | `perl -MO=C,-o build/perl-bc/<name>` | Generates `.c` files |
| bundle | verify C output | Checks `build/perl-bc/**/*.c` |
| test | `prove -l t/` or `make test` | When tests are available |

## Detection

- Markers: `Makefile.PL`, `**/*.pl`
- Entry points: `app.pl`, `main.pl`, or first non-test `*.pl`
- Binary: `perl` (override with `PERL` env or `perl_binary` config)
- Scope: `perl-bc`

## License

Apache License 2.0.
