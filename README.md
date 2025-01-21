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

# Define attributes and actions for resource (Music/Artist)

# Create migrations - mix ash.codegen create_artists

# Run migrations - mix ash.migrate

**Generate LiveView**

mix ash_phoenix.gen.live --domain Tuneshg.Music --resource Tuneshg.Music.Artist --resourceplural artists

**Working with AshPhoenix.Form**

form = AshPhoenix.Form.for_create(Tunez.Music.Artist, :create)
AshPhoenix.Form.validate(form, %{name: "Best Band Ever"})
AshPhoenix.Form.submit(form, params: %{name: "Best Band Ever"})

**Working with domain extensions**

defmodule Tuneshg.Music do
use Ash.Domain, extensions: [AshPhoenix]

The AshPhoenix extension adds `form_to_...` functions to the access-funktions of the domain

At example:
form = Tuneshg.Music.form_to_create_artist()

# chapter 2

**relationships**

# Album Domain

```
relationships do
  belongs_to :artist, Tuneshg.Music.Artist do
    allow_nil? false
  end
end
```

# artist

```
relationships do
  has_many :albums, Tuneshg.Music.Album
end
```
