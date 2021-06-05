defmodule UnderChat.Repo do
  use Ecto.Repo,
    otp_app: :underchat,
    adapter: Ecto.Adapters.Postgres
end
