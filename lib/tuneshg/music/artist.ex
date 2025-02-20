defmodule Tuneshg.Music.Artist do
  use Ash.Resource, otp_app: :tuneshg, domain: Tuneshg.Music, data_layer: AshPostgres.DataLayer

  postgres do
    table "artists"
    repo Tuneshg.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
    default_accept [:name, :biography]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end

    attribute :biography, :string
    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    has_many :albums, Tuneshg.Music.Album
  end
end
