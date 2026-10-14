# Ruby

Ruby interpreter — syntax validation for auto-detected *.rb targets

Plugin ID: **`coditary/ruby`**

## Install

```lua
reqpack { beez = { { name = "coditary/ruby", version = "1.0.0", source = "github:Coditary/beez-ruby" } } }
```

## Usage

```lua
configure({ { "coditary/ruby", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[ruby]
beez -s coditary/ruby:compile:code
```

## Detection

- Markers: `**/*.rb`, `Gemfile`
- Binary: `ruby` (override with `RUBY` env or config)

## License

Apache License 2.0.
