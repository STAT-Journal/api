defmodule Stat.Repo do
  use Ecto.Repo,
    otp_app: :stat,
    adapter: Application.compile_env!(:stat, [Stat.Repo, :adapter])
end
