# soul

Official SOUL plugin — compile audio patches (`*.soul`) to C++ via the SOUL toolchain.

Plugin ID: **`coditary/soul`**

## Install

```lua
reqpack { beez = { { name = "coditary/soul", version = "1.0.0", source = "github:Coditary/beez-soul" } } }
```

## Usage

```lua
configure({ { "coditary/soul", {} } })
```

```bash
beez -p compile[soul]
beez -s soul:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `soul` | `soul --version` | Verifies SOUL binary |
| compile | `soul` | `soul compile … --output=…` | Generates `build/soul/bin/app.cpp` |
| bundle | `soul` | verify output | Checks generated C++ file |
| test | `soul` | compile validation | Re-compiles patch when tests exist |

## Detection

- Markers: `**/*.soul`
- Entry point: first non-test `*.soul`, or `entry_source` in configure()
- Tests: `test/**/*.soul`, `test_*.soul`, `*_test.soul`

## License

Apache License 2.0.
