# erlc

Official Erlang/OTP compiler plugin — `erlc` standalone, `rebar3`, or Erlang-only `mix` with auto-detected sources.

Plugin ID: **`coditary/erlc`**

## Install

```lua
reqpack { beez = { { name = "coditary/erlc", version = "1.0.0", source = "github:Coditary/beez-erlc" } } }
```

## Usage

```lua
configure({ { "coditary/erlc", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[erlang]
beez -s erlc:compile
```

## Detection

| Marker | Backend |
|--------|---------|
| `rebar.config` | rebar3 (`get-deps`, `compile`, `eunit`) |
| `mix.exs` (Erlang-only, no `.ex` sources) | mix (`deps.get`, `compile`, `test`) |
| `**/*.erl` / `**/*.hrl` (no rebar/mix) | Standalone `erlc` |

BEAM bytecode is collected under `build/erlc/ebin/`.

## Scope

Release builds use scope **`erlang`** (not `app`), matching Erlang/OTP pipeline conventions.

## License

Apache License 2.0.
