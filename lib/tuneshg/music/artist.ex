defmodule Tuneshg.Music.Artist do
  use Ash.Resource, otp_app: :tuneshg, domain: Tuneshg.Music, data_layer: AshPostgres.DataLayer

  postgres do
    table "artists"
    repo Tuneshg.Repo
  end
end
