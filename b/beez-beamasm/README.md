# beamasm

**BEAM JIT compiler plugin** — modern Erlang/OTP JIT via `erlc` / `erl +jit` with rebar3, Erlang-only mix, or standalone erlc auto-detection.

Plugin ID: **`coditary/beamasm`**

## Install

```lua
reqpack { beez = { { name = "coditary/beamasm", version = "1.0.0", source = "github:Coditary/beez-beamasm" } } }
```

## Usage

```lua
configure({ { "coditary/beamasm", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[beamasm]
beez -s beamasm:compile
```

## Detection

| Marker | Backend |
|--------|---------|
| `rebar.config` | rebar3 (`get-deps`, `compile`, `eunit`) |
| `mix.exs` (Erlang-only, no `.ex` sources) | mix (`deps.get`, `compile`, `test`) |
| `**/*.erl` / `**/*.hrl` (no rebar/mix) | Standalone `erlc` |

BEAM bytecode is collected under `build/beamasm/ebin/`. The bundle step installs an `erl +jit` launcher at `build/beamasm/bin/app`.

## Scope

JIT builds use scope **`beamasm`** (not `app`), matching the BEAM JIT compiler pipeline.

## Requirements

- OTP 24+ with built-in BEAM JIT (`erl +jit`)
- `rebar3` on `PATH` for rebar-based projects
- `mix` on `PATH` for Erlang-only mix projects

## License

Apache License 2.0.
