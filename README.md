# RockBot

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `rock_bot` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:rock_bot, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/rock_bot](https://hexdocs.pm/rock_bot).

## Release

rename config/erlang_cookie.example to config/erlang_cookie
generate cookie and put in this file
run
```sh
export REPLACE_OS_VARS=true
```
run
```sh
MIX_ENV=prod mix release
```
