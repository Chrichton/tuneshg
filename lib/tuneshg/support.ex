defmodule Tuneshg.Support do
  use Ash.Domain,
    otp_app: :tuneshg

  resources do
    resource Tuneshg.Support.Ticket
    resource Tuneshg.Support.Representative
  end
end
