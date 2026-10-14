# terraform

Official Terraform plugin — initialize, validate, and plan HCL infrastructure configurations.

Plugin ID: **`coditary/terraform`**

## Install

```lua
reqpack { beez = { { name = "coditary/terraform", version = "1.0.0", source = "github:Coditary/beez-terraform" } } }
```

## Usage

```lua
configure({ { "coditary/terraform", {} } })
```

```bash
beez -p compile[terraform]
beez -s terraform:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `terraform` | `terraform init -backend=false` | Verifies CLI and providers |
| compile | `terraform` | `terraform validate && plan` | Writes plan to `build/terraform/bin/` |
| bundle | `terraform` | verify plan | Checks plan and validate stamp |
| test | `terraform` | `terraform fmt -check` | Validates formatting and HCL |

## Detection

- Markers: `**/*.tf`, `terraform.tfvars`
- Entry point: `main.tf`, then first non-test `*.tf`, or `entry_source` in configure()

## License

Apache License 2.0.
