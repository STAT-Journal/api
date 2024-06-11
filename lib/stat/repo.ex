defmodule Stat.Repo do
  use Ecto.Repo,
    otp_app: :stat,
    adapter: Ecto.Adapters.SQLite3
end
