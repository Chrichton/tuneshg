defmodule Tuneshg.Music do
  use Ash.Domain,
    otp_app: :tuneshg

  resources do
    resource Tuneshg.Music.Artist
  end
end
