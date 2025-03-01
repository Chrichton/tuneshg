defmodule Tuneshg.Music.Artist do
  use Ash.Resource, otp_app: :tuneshg, domain: Tuneshg.Music, data_layer: AshPostgres.DataLayer

  postgres do
    table "artists"
    repo Tuneshg.Repo

    custom_indexes do
      index "name gin_trgm_ops", name: "artists_name_gin_index", using: "GIN"
    end
  end

  actions do
    defaults [:create, :read, :update, :destroy]
    default_accept [:name, :biography]

    read :search do
      description "List Artists, optionally filtering by name."

      argument :query, :ci_string do
        description "Return only artists with names including the given value."
        constraints allow_empty?: true
        default ""
      end

      prepare build(select: [:id, :name])

      filter expr(contains(name, ^arg(:query)))

      # pagination offset?: true, default_limit: 12
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    attribute :biography, :string
    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    has_many :albums, Tuneshg.Music.Album
  end
end
