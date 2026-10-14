# nix

Official Nix plugin — build and check Nix expressions from flake.nix or default.nix.

Plugin ID: **`coditary/nix`**

## Install

```lua
reqpack { beez = { { name = "coditary/nix", version = "1.0.0", source = "github:Coditary/beez-nix" } } }
```

## Usage

```lua
configure({ { "coditary/nix", {} } })
```

```bash
beez -p compile[nix]
beez -s nix:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `nix` | `nix --version` + parse/metadata | Verifies Nix CLI |
| compile | `nix` | `nix build` or `nix-instantiate` | Writes result link to `build/nix/bin/` |
| bundle | `nix` | verify result | Checks build stamp and result link |
| test | `nix` | `nix flake check` or parse | Validates Nix expressions |

## Detection

- Markers: `flake.nix`, `**/*.nix`, `default.nix`
- Entry point: `flake.nix`, then `default.nix`, then first non-test `*.nix`, or `entry_source` in configure()
- Flake projects use `nix build`; classic projects use `nix-instantiate`

## License

Apache License 2.0.
