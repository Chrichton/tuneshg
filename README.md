# Tuneshg

To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix

## Created via

mix archive.install hex phx_new

mix igniter.new tuneshg \
 --install ash,ash_postgres,ash_phoenix \
 --with phx.new \
 --extend postgres \
 --example

**Link**:
[HexDocs Ash Getting started](https://hexdocs.pm/ash/get-started.html)

**Create Domain and Resource**

mix ash.gen.domain Tuneshg.Music
mix ash.gen.resource Tuneshg.Music.Artist --extend postgres

# Define attributes for resource (Music/Artist)

# Create migrations - mix ash.codegen create_artists

# Run migrations - mix ash.migrate
