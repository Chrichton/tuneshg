defmodule Tuneshg.Music.Album do
  use Ash.Resource, otp_app: :tuneshg, domain: Tuneshg.Music, data_layer: AshPostgres.DataLayer

  postgres do
    table "albums"
    repo Tuneshg.Repo
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      accept [:name, :year_released, :cover_image_url, :artist_id]
    end

    update :update do
      accept [:name, :year_released, :cover_image_url, :artist_id]
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end

    attribute :year_released, :integer do
      allow_nil? false
    end

    attribute :cover_image_url, :string
    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :artist, Tuneshg.Music.Artist do
      allow_nil? false
    end
  end
end
