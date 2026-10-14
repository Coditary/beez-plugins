# virtual-pascal

**Virtual Pascal** — historical 32-bit Pascal compiler for OS/2 and Microsoft Windows with auto-detected `*.vpj` and `**/*.pas` targets.

Plugin ID: **`coditary/virtual-pascal`**

> **Legacy notice:** Virtual Pascal (VP 2.1) is a discontinued, historical compiler
> originally developed by Vitaly Miryanov and later maintained by Allan Mertner
> (1996–2006). It targets 32-bit OS/2 and Windows and produces native executables for
> those platforms only. The project was never open-sourced. Modern Pascal projects
> should prefer [Free Pascal (FPC)](https://www.freepascal.org/) or
> [Delphi](https://www.embarcadero.com/products/delphi).
> This plugin exists for maintaining legacy OS/2 and Windows codebases and historical
> builds only.

## Install

```lua
reqpack { beez = { { name = "coditary/virtual-pascal", version = "1.0.0", source = "github:Coditary/beez-virtual-pascal" } } }
```

## Usage

```lua
configure({ { "coditary/virtual-pascal", {} } })
```

```bash
beez -p setup[virtual-pascal]
beez -p compile[virtual-pascal]
beez -p bundle[virtual-pascal]
beez -p test[virtual-pascal]
beez -s virtual-pascal:compile
```

Build artifacts are written to `build/virtual-pascal/bin/`.

## Detection

| Marker | Role |
|--------|------|
| `*.vpj` | Virtual Pascal project (primary) |
| `*.dpr` | Delphi/Borland program (fallback) |
| `**/*.pas` | Single-unit Pascal source (fallback) |

Release builds use `-B` (build all units) with `-E` pointing at `build/virtual-pascal/bin/`.

## Requirements

Virtual Pascal is a **Windows/OS/2-native** toolchain. You need one of:

| Component | Role |
|-----------|------|
| **`vpc`** | Virtual Pascal compiler driver (preferred) |
| **`vpcc`** | Virtual Pascal command-line compiler (alternative) |
| **`vp.vpo`** | Compiler options file (default; override with `vpo_file`) |
| **Wine / OS/2 / Windows host** | Run `vpc`/`vpcc` and produced `.exe` files on modern Linux |

Place a wrapper script named `vpc` on `PATH` that invokes the real compiler, or set
`vpc_binary = "vpcc"` in `configure()`:

```lua
configure({ { "coditary/virtual-pascal", {
  vpc_binary = "vpcc",
  vpo_file = "vp.vpo",
} } })
```

The `VPC_BINARY` environment variable overrides the default compiler binary.

## Other Pascal compilers

| Plugin | Compiler | Use case |
|--------|----------|----------|
| `coditary/virtual-pascal` | **Virtual Pascal** | Legacy OS/2/Windows 32-bit (this plugin) |
| `coditary/turbopascal` | **Turbo Pascal** | Legacy DOS |
| `coditary/fpc` | **Free Pascal** | Modern cross-platform Pascal |
| `coditary/delphi` | **Delphi** | Modern Windows/macOS/mobile |

Load only the compiler plugin you need.

## License

Apache License 2.0.
