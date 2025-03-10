defmodule Tuneshg.Support.Ticket do
  use Ash.Resource, otp_app: :tuneshg, domain: Tuneshg.Support, data_layer: AshPostgres.DataLayer

  postgres do
    table "tickets"
    repo Tuneshg.Repo
  end

  actions do
    defaults [:read]

    create :open do
      accept [:subject]
    end

    update :close do
      accept []

      validate attribute_does_not_equal(:status, :closed) do
        message "Ticket is already closed"
      end

      change set_attribute(:status, :closed)
    end

    update :assign do
      accept [:representative_id]
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :subject, :string do
      allow_nil? false
      public? true
    end

    attribute :status, :ticket_status do
      default :open
      allow_nil? false
    end
  end

  relationships do
    belongs_to :representative, Tuneshg.Support.Representative do
      public? true
    end
  end
end
